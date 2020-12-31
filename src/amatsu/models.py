from django.db import models
import datetime

class Url(models.Model):
  fullUrl = models.CharField(max_length=1024)
  hashOfUrl = models.CharField(max_length=6)
  shortenedUrl = models.CharField(max_length=32)
  hits = models.IntegerField()
  isCustom = models.BooleanField(default=False)
  madeByExtension = models.BooleanField(default=False)

class IP(models.Model):
  ip = models.CharField(max_length=15)
  lastUsed = models.DateTimeField(default=datetime.datetime.now)

