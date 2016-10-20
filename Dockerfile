FROM ruby:2.3.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 80 443
CMD [ "rails", "server", "-b", "0.0.0.0", "-p", "8080" ]
