#!/bin/bash

echo "Connecting with following environment:"

echo "-----------------------------------------------------------"
env
echo "-----------------------------------------------------------"

bundle exec rake db:reset # TEMPORARY
bundle exec rake db:setup || \
echo "Database couldn't be setup. It already have initialised"

bundle exec rake db:migrate && \
bundle exec rails server -b 0.0.0.0 -p $RAILS_PORT
