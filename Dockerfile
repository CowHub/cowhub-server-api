FROM ruby:2.3.1

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080" ]
