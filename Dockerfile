FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY src /code/

RUN ls /code/
RUN ls /code/amatsu/

ENTRYPOINT ["/code/entrypoint.sh"]
