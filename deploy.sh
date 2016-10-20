#!/usr/bin/env bash

# Build latest image
cd /app
docker build -t cowhub-server-api .

# Take service down
docker kill cowhub-server-api

# Bring service up (with latest)
docker run -d -p 80:80 -i cowhub-server-api
