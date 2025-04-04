# Use an official Python runtime as a parent image
FROM python:3.12-alpine

# Set the working directory in the container
WORKDIR /app

# Install available updates / dependencies / python packages from requirements.txt,
# perform cleanup, copy scripts to /usr/local/bin and make executable.
RUN set -ex \
    && apk upgrade --update --available --no-cache \
    && apk add --no-cache bash curl git jq \
    && rm -rf /var/cache/apk/* \
    && pip install --no-cache-dir -r requirements.txt \
    && pip cache purge \
    && cp scripts/* /usr/local/bin/ \
    && chmod +x /usr/local/bin/*
