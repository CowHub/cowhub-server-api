FROM ruby:2.3.1

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

ENV RAILS_PORT 8080
EXPOSE 8080
CMD [ "/bin/bash", "-c", "/app/deploy.sh" ]
