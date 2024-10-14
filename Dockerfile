# Use an official Python runtime as a parent image
FROM python:3.12-alpine

# Install available updates, dependencies and python packages from requirements.txt
RUN set -ex \
    && apk upgrade --update --available --no-cache \
    && apk add --no-cache bash curl git jq \
    && rm -rf /var/cache/apk/* \
    && pip install --no-cache-dir -r requirements.txt \
    && pip cache purge
