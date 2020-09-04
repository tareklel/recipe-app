FROM python:3.7-alpine
MAINTAINER Tarek Lel
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /requirements.txt
# no-cache decreases docker footprint
RUN apk add --update --no-cache postgresql-client jpeg-dev
# install dependencies needed while installing requirements in pip
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
# remove dependancies after pip postgres installed
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

#to store recipe iages
RUN mkdir -p /vol/web/media
# for js css and other static file
RUN mkdir -p /vol/web/static
RUN adduser -D user
#sets ownership of volume directory to user
RUN chown -R user:user /vol
#user can modify directory
RUN chmod -R 755 /vol/web
USER user