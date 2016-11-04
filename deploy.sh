#!/usr/bin/env bash

# Take service down
docker rm -f $(docker ps -a -q)

# Bring service up
docker-compose -f /docker-compose-production.yml pull
docker-compose -f /docker-compose-production.yml up -d
docker-compose -f /docker-compose-production.yml run api bundle exec rake db:migrate
