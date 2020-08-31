FROM python:3.7-alpine
MAINTAINER Tarek Lel
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /requirements.txt
# no-cache decreases docker footprint
RUN apk add --update --no-cache postgresql-client
# install dependencies needed while installing requirements in pip
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
# remove dependancies after pip postgres installed
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user