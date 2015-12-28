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

def index(request):
  template = django.template.loader.get_template("index.html")
  randomizedForm = hashlib.md5(str(time.time())).hexdigest()
  context = RequestContext(request, {"randomizedID":randomizedForm})
  html = template.render(context)
  return HttpResponse(html)

def toHomepage(request):
  return django.shortcuts.redirect("/kaze/")

def redirect(request):
  template = django.template.loader.get_template("index2.html")
  context = RequestContext(request, {})
  html = template.render(context)
  return HttpResponse(html)

def api(request):
  print request.POST
  url = request.POST["url"]

  validator = URLValidator(verify_exists=False)
  try:
    validator(url)

    hashed = url
    collission = False
    while not collission:
      hashed = hashlib.md5(hashed).hexdigest()[:6]
      print hashed

    urlObj = models.Url(FullUrl=url,hashOfUrl=hashed,shortenedUrl=returnUrl)
    urlObj.save()
    return HttpResponse(returnUrl, content_type="text/plain")
  except ValidationError, e:
    print e
    return HttpResponse("Nope", content_type="text/plain")





