FROM python:3

ARG IS_PROD
ENV IS_PRODUCTION=$IS_PROD
ENV PYTHONUNBUFFERED 1
RUN echo "IS_PRODUCTION IS SET TO: ${IS_PRODUCTION}"
RUN echo "PYTHONBUFFERED IS SET TO: ${PYTHONBUFFERED}"

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

