from django.db import models

class Url(models.Model):
  fullUrl = models.CharField(max_length=1024)
  hashOfUrl = models.CharField(max_length=6)
  shortenedUrl = models.CharField(max_length=32)
  hits = models.IntegerField()
  isCustom = models.BooleanField(default=False)

