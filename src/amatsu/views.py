import django

from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError
from django.http import HttpResponse, Http404
from django.template import Template, Context, RequestContext
from django.shortcuts import render

import os
import re
import sys
import time
import pytz
import hashlib
import requests
import datetime

from amatsu import models, hasher


# For easier switching between test and production servers
HOST_URL = (
    os.environ.get("VIRTUAL_HOST")
    if os.environ.get("VIRTUAL_HOST")
    else settings.REMI_DEV_VM_HOST
)

import logging
formatter = logging.Formatter("[%(asctime)s][%(levelname)s] %(message)s")

stream_handler = logging.StreamHandler(sys.stdout)
stream_handler.setLevel(logging.DEBUG)
stream_handler.setFormatter(formatter)

is_dev = "dev" in HOST_URL or settings.REMI_DEV_VM_HOST in HOST_URL
logger = logging.getLogger("amatsu-dev" if is_dev else "amatsu-prod")
logger.setLevel(logging.DEBUG if is_dev else logging.WARNING)
logger.addHandler(stream_handler)

logger.debug("Testing debug level log")
logger.warning("Testing warning level log")

def index(request):
    template = django.template.loader.get_template("index.html")
    randomizedForm = hashlib.md5(str(time.time()).encode()).hexdigest()
    context = {"randomizedID": randomizedForm, "hostname": HOST_URL}
    html = template.render(context, request=request)
    return HttpResponse(html)


def toHomepage(request):
    return django.shortcuts.redirect("/kaze/")


def redirect(request, hashed=None):
    if hashed == None:
        return django.shortcuts.redirect("/kaze/")

    check = models.Url.objects.filter(hashOfUrl=hashed)
    if len(check) > 0:
        destUrl = check[0].fullUrl
        check[0].hits += 1
        check[0].save()
        return django.shortcuts.redirect(destUrl)
    else:
        return django.shortcuts.redirect(HOST_URL + "/kaze/")


@csrf_exempt
def api(request):

    if (
        "url" not in request.POST
        or (
            "customSuffix" not in request.POST and "customURL" not in request.POST
        )  # customURL backwards compatibility for ff/chrome extensions
        or (
            "csrfmiddlewaretoken" not in request.POST
            and "isFromExtension" not in request.POST
        )
    ):
        logger.debug(f"Missing required post field params. Rejecting - {request} - {request.POST}")
        raise Http404

    # Need client IP for flood prevention so need this header.
    # It's a required header to be standard-compliant.
    if "REMOTE_ADDR" not in request.META:
        logger.debug(f"Got request with no REMOTE_ADDR set. Rejecting - {request} - {request.POST}")
        return HttpResponse(
            "Oops, seems like you're using a non-standard compliant browser!",
            content_type="text/plain",
            status=406,
        )
    if __shouldAntiFloodActivate(request.META["REMOTE_ADDR"]):
        logger.debug(f"Anti Flood activated. Rejecting - {request} - {request.POST}")
        return HttpResponse(
            "Slow down! You're making too many requests!",
            content_type="text/plain",
            status=429,
        )

    isFromExtension = "isFromExtension" in request.POST
    url = str(request.POST["url"])
    customSuffix = (
        request.POST["customSuffix"]
        if "customSuffix" in request.POST
        else request.POST["customURL"]
    )

    # If we have a custom URL, then validate it.
    if customSuffix != "":
        p = re.compile("[^a-zA-Z-_0-9]")
        results = p.search(customSuffix)

        # If not valid, return error message.
        if results != None:
            logger.debug(f"Invalid characters in custom suffix. Rejecting - {request} - {request.POST}")
            return HttpResponse(
                "Custom URLs can only contain alphanumeric symbols, - and _",
                content_type="text/plain",
                status=400,
            )
        if len(customSuffix) < 4 or len(customSuffix) > 32:
            logger.debug(f"Invalid custom suffix length. Rejecting - {request} - {request.POST}")
            return HttpResponse(
                "Custom URLs must be between 4 and 32 characters long!",
                content_type="text/plain",
                status=400,
            )

    return __processUrl(url, customSuffix, isFromExtension)


def __processUrl(url: str, customSuffix: str, isFromExtension: bool):
    validator = URLValidator()
    try:
        # Validate url to make sure it's valid
        validator(url)
    except ValidationError as e:
        logger.warning(f"Invalid URL submitted. Rejecting - {e}")
        return HttpResponse(
            "Please enter a valid and full url!", content_type="text/plain", status=400
        )

    # First check if we have a custom url.
    # If so, we override the preexisting checks.
    if customSuffix != "":
        try:
            # Check if customSuffix is already in use or not
            url_obj = models.Url.objects.get(hashOfUrl=customSuffix)
            # Only error out if custom suffix is used AND dest link are different.
            if url_obj.fullUrl != url:
                logger.debug(f"Got a custom suffix that's already in use for a different dest link. Rejecting - {request} - {request.POST}")
                return HttpResponse(
                    "That custom URL is already in use!",
                    content_type="text/plain",
                    status=400,
                )
        except models.Url.DoesNotExist:
            pass

        urlSuffix = customSuffix
    else:
        # But if it doesn't already exist, just process like normal
        urlSuffix = __generateOrGetUrlSuffix(url)

    fullShortenedUrl = f"{HOST_URL}{urlSuffix}"

    if not models.Url.objects.filter(hashOfUrl=urlSuffix).exists():
        urlObj = models.Url(
            fullUrl=url,
            hashOfUrl=urlSuffix,
            shortenedUrl=fullShortenedUrl,
            isCustom=(customSuffix != ""),
            madeByExtension=isFromExtension,
        )
        try:
            urlObj.save()
        except:
            logger.warning(f"Failed to save urlObj. What? - {request} - {request.POST}")
            return HttpResponse(
                "Oops something broke! Try again in a bit!",
                content_type="text/plain",
                status=500,
            )

    return HttpResponse(fullShortenedUrl, content_type="text/plain", status=200)


def __generateOrGetUrlSuffix(url: str) -> str:
    # First check if we've already hashed this url. If so, return suffix/hash.
    urlObjs = models.Url.objects.filter(fullUrl=url)
    if len(urlObjs) > 0:
        for urlObj in urlObjs:
            if urlObj.isCustom == False:
                return urlObj.hashOfUrl

    # Otherwise generate a new suffix/hash
    urlSuffix = str(url)
    collission = True
    while collission:
        urlSuffix = hasher.returnShortenedSuffix(urlSuffix)
        if len(models.Url.objects.filter(hashOfUrl=urlSuffix)) == 0:
            collission = False

    return urlSuffix


def __shouldAntiFloodActivate(remote_addr: str) -> bool:
    try:
        ipObj = models.IP.objects.get(ip=remote_addr)

        # eg, 2016-01-12 16:22:22.129932+00:00
        now = datetime.datetime.now(tz=pytz.utc)
        # If requests are too quick
        if (__formatTime(now) - __formatTime(ipObj.lastUsed)) <= datetime.timedelta(
            milliseconds=1000
        ):
            return True

        ipObj.lastUsed = now
    except IP.DoesNotExist:
        ipObj = models.IP(ip=remote_addr)

    ipObj.save()
    return False


def __formatTime(inp):
    inp = str(inp)
    if inp.find("+") > -1:
        time = inp[: inp.find("+")]
    try:
        return datetime.datetime.strptime(time, "%Y-%m-%d %H:%M:%S.%f")
    except:
        # Yikes. Py2 vs py3 datetime default behavior differences.
        return datetime.datetime.strptime(time, "%Y-%m-%d %H:%M:%S")
