#!/usr/bin/env bash

# Build latest image
cd /app

# Take service down
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

# Bring service up (with latest)
docker build -t cowhub-server-api .
docker run -d -p 80:80 -i cowhub-server-api
