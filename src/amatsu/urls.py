from amatsu import views

from django.conf import settings
from django.conf.urls import include, url
from django.conf.urls.static import static

# from django.contrib import admin

urlpatterns = [
    # Examples:
    # url(r'^$', 'amatsu.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r"^api[/]$", views.api),
    url(r"^kaze[/]?$", views.index),
    url(r"^kaze/(?P<hashed>[a-zA-Z0-9\_\-]{4,32})/?$", views.redirect),
    url(r"^(?P<hashed>[a-zA-Z0-9\_\-]{4,32})/?$", views.redirect),
    url(r"^$", views.toHomepage),
    url(r".*", views.redirect),
]
