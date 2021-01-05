FROM python:3
ARG IS_PRODUCTION
ENV IS_PRODUCTION $IS_PRODUCTION
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
RUN ls /app/static/

ENTRYPOINT ["/app/entrypoint.sh"]

