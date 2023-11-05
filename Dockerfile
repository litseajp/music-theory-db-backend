FROM ruby:3.2.2 

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install
