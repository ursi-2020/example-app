import os

from django.apps import AppConfig
from apipkg import api_manager as api

myappurl = "http://localhost:" + os.environ["WEBSERVER_PORT"]


class ApplicationConfig(AppConfig):
    name = 'application.djangoapp'

    def ready(self):
        api.unregister(os.environ['DJANGO_APP_NAME'])
        api.register(myappurl, os.environ['DJANGO_APP_NAME'])