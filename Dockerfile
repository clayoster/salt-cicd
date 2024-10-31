# Use an official Python runtime as a parent image
FROM python:3.12-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Copy the files from the scripts directory to /usr/local/bin
COPY scripts/ /usr/local/bin/

# Install available updates / dependencies / python packages from requirements.txt,
# perform cleanup and ensure the scripts in /usr/local/bin are executable.
# 
RUN set -ex \
    && apk upgrade --update --available --no-cache \
    && apk add --no-cache bash curl git jq \
    && rm -rf /var/cache/apk/* \
    && pip install --no-cache-dir -r requirements.txt \
    && pip cache purge \
    && rm -rf /app \
    && chmod +x /usr/local/bin/*
