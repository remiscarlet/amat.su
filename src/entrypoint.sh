#!/bin/bash

# For dev
#python3 manage.py runserver 0.0.0.0:${VIRTUAL_PORT}

# For prod
cd amatsu; gunicorn amatsu.wsgi --user www-data --bind 0.0.0.0:${VIRTUAL_PORT} --workers 2
