#!/usr/bin/env bash

# Take service down
docker rm -f $(docker ps -a -q)

# Bring service up
docker-compose -f /docker-compose-production.yml pull
docker-compose -f /docker-compose-production.yml up -d
