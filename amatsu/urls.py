from django.conf.urls import patterns, include, url
from django.contrib import admin
import views

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'amatsu.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^api[/]$', views.api),
    url(r'^kaze[/]$', views.index),
    url(r'^$', views.toHomepage),
    url(r'^[a-zA-Z0-9]{6}[/]{0,1}$',views.redirect),
    url(r'.*', views.toHomepage),
)
