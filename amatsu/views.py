from django.http import HttpResponse
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
    return django.shortcuts.redirect("http://localhost:8000/kaze/")

def api(request):
  print request.POST
  url = request.POST["url"]

  validator = URLValidator()

  try:
    validator(url)
    check = models.Url.objects.filter(fullUrl=url)
    if len(check) >0:
      returnUrl = check[0].shortenedUrl
      print "already exists",returnUrl
      return HttpResponse(returnUrl, content_type="text/plain")

    hashed = url
    collission = True
    while collission:
      hashed = hasher.returnShortenedURL(hashed)

      if len(models.Url.objects.filter(hashOfUrl=hashed)) == 0:
        collission = False
    #returnUrl = "http://amat.su/"+hashed
    returnUrl = "http://localhost:8000/"+hashed
    urlObj = models.Url(fullUrl=url,hashOfUrl=hashed,shortenedUrl=returnUrl,hits=0)
    urlObj.save()

    return HttpResponse(returnUrl, content_type="text/plain")
  except ValidationError, e:

    print e
    return HttpResponse("Please enter a valid and full url!", content_type="text/plain")





