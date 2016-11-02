#!/usr/bin/env bash

# Build latest image
cd /app

# Take service down
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images | grep -v 'REPOSITORY' | grep -v 'cowhub-server-api' | grep -v 'ruby' | awk -F ' ' '{ print $3 }')

# Bring service up (with latest)
docker build -t cowhub-server-api .
docker run -d -p 443:8080 --name cowhub-server-api -i cowhub-server-api
