#!/bin/bash

# For dev
#python3 manage.py runserver 0.0.0.0:${VIRTUAL_PORT}

# For prod
gunicorn wsgi --user ${GUNICORN_USER} --bind 0.0.0.0:${VIRTUAL_PORT} --workers 2
