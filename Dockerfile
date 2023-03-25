FROM python:3.11.2-alpine3.16
LABEL maintainer="rogasiu"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./task_manager /task_manager
WORKDIR /task_manager
EXPOSE 8000

ARG DEV=false
RUN pip install --upgrade pip && \
	apk add --update --no-cache postgresql-client && \
	apk add --update --no-cache --virtual .tmp-build-deps \
		build-base postgresql-dev musl-dev && \
	pip install -r /tmp/requirements.txt && \
	if [ $DEV = "true" ]; \
		then pip install -r /tmp/requirements.dev.txt ; \
	fi && \
	rm -rf /tmp && \
	apk del .tmp-build-deps
