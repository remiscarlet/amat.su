FROM python:3
ENV PYTHONUNBUFFERED 1

# Amat.su
RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app/
RUN pip install -r requirements.txt
COPY src /app/

RUN python manage.py collectstatic --noinput

RUN ls /
RUN ls /app/
RUN ls /app/amatsu/
RUN echo "----"
RUN cat /app/static/js/funcs.js
RUN echo "----"
RUN cat /app/amatsu/static/js/funcs.js

ENTRYPOINT ["/app/entrypoint.sh"]

