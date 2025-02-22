FROM ruby:latest

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY gmail_reader.rb ./
COPY credentials.json ./
