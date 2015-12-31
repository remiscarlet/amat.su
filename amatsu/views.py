from django.http import HttpResponse, Http404
from django.template import Template, Context, RequestContext
from django.shortcuts import render
import django
from django.views.decorators.csrf import csrf_exempt
import hashlib, time
from amatsu import models
import requests
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError
import hasher
import re

# For easier switching between test and production servers
HOST_URL = "http://amat.su/"

def index(request):
  template = django.template.loader.get_template("index.html")
  randomizedForm = hashlib.md5(str(time.time())).hexdigest()
  context = RequestContext(request, {"randomizedID":randomizedForm})
  html = template.render(context)
  return HttpResponse(html)

def toHomepage(request):
  return django.shortcuts.redirect("/kaze/")

def redirect(request,hashed=None):
  print "hashed =",hashed
  if hashed == None:
    return django.shortcuts.redirect("/kaze/")

  print hashed
  check = models.Url.objects.filter(hashOfUrl=hashed)
  if len(check) >0:
    destUrl = check[0].fullUrl
    check[0].hits += 1
    check[0].save()
    return django.shortcuts.redirect(destUrl)
  else:
    return django.shortcuts.redirect(HOST_URL+"/kaze/")

def api(request):

  if ("url" not in request.POST or
      "csrfmiddlewaretoken" not in request.POST or
      "customURL" not in request.POST):
    print request.POST
    raise Http404

  url = request.POST["url"]
  customURL = request.POST["customURL"]

  # If we have a custom URL, then validate it.
  if customURL != "":
    p = re.compile("[^a-zA-Z-_0-9]")
    results = p.search(customURL)

    # If not valid, return error message.
    if results != None:
      return HttpResponse("Custom URLs can only contain alphanumeric symbols, - and _", content_type="text/plain")
    if len(customURL) <4 or len(customURL) > 32:
      return HttpResponse("Custom URLs must be between 4 and 32 characters long!", content_type="text/plain")



  validator = URLValidator()
  try:
    # Validate url
    validator(url)

    # First check if we have a custom url. 
    # If so, we override the preexisting checks.
    if customURL != "":
      # Check if customURL is already in use or not
      existingCheck = models.Url.objects.filter(hashOfUrl=customURL)
      if len(existingCheck) > 0:

        # Check if that full url already exists, eg the exact same parameters
        if existingCheck[0].fullUrl == url:
          # Already existed with exact same shortening so might as well return it
          return HttpResponse(existingCheck[0].shortenedUrl, content_type="text/plain")
        
        # Otherwise we have a conflicting customURL to different redirects
        return HttpResponse("That custom URL is already in use!", content_type="text/plain")

      # Else, we're good.
      returnUrl = HOST_URL+customURL
      urlObj = models.Url(fullUrl=url,hashOfUrl=customURL,shortenedUrl=returnUrl,hits=0)
      urlObj.save()
      return HttpResponse(returnUrl, content_type="text/plain")


    # check = models.Url.objects.filter(fullUrl=url)
    # if len(check) >0:
    #   returnUrl = check[0].shortenedUrl
    #   print "already exists",returnUrl
    #   return HttpResponse(returnUrl, content_type="text/plain")

    hashed = url
    collission = True
    while collission:
      hashed = hasher.returnShortenedURL(hashed)

      if len(models.Url.objects.filter(hashOfUrl=hashed)) == 0:
        collission = False
    returnUrl = HOST_URL+hashed
    urlObj = models.Url(fullUrl=url,hashOfUrl=hashed,shortenedUrl=returnUrl,hits=0)
    urlObj.save()

    return HttpResponse(returnUrl, content_type="text/plain")
  except ValidationError, e:

    print e
    return HttpResponse("Please enter a valid and full url!", content_type="text/plain")





