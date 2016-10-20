FROM ruby:2.3.1

ENV RAILS_ENV production

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install

COPY . .

RUN bundle exec rake db:setup db:migrate

EXPOSE 8080
CMD [ "rails", "server", "-b", "0.0.0.0", "-p", "8080" ]
