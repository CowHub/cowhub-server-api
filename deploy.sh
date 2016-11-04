#!/usr/bin/env bash

# Take service down
docker rm -f $(docker ps -a -q)

# Bring service up
docker-compose up -d -f /docker-compose-production.yml --force-recreate
