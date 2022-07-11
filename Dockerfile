FROM ruby:2.1.10-alpine


ARG bundle_without=development:test

RUN apk add --no-cache \
  bash \
  # Bundler needs it to install forks and github sources.
  git \
  # NodeJS
  nodejs \
  # Gems need the dev-headers/compilers.
  build-base \
  libxml2-dev \
  libxslt-dev \
  # SQLite adapter needs the development headers.
  postgresql-dev \
  # ARM64 support
  libc6-compat


RUN mkdir /app
WORKDIR /app

COPY ./ ./

ENV BUNDLE_WITHOUT=$bundle_without
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --no-cache

EXPOSE 3000

CMD bundle exec rails server