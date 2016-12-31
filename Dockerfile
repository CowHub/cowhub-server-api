FROM ruby:2.3.1

RUN apt-get install -y --no-install-recommends postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080" ]
