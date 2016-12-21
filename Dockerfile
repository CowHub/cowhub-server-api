FROM ruby:2.3.1

RUN curl -sSL https://deb.nodesource.com/setup_7.x | bash
RUN apt-get install -y nodejs build-essential
RUN apt-get install -y --no-install-recommends postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD [ "/bin/bash", "-c", "npm start" ]
