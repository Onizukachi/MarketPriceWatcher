ARG RUBY_VERSION=3.3.5

FROM ruby:$RUBY_VERSION-alpine

# Bot app lives here
WORKDIR /app

# Install packages needed to build gems and libraries
RUN apk update && apk upgrade && \
    apk add --no-cache build-base tzdata postgresql-dev libxslt-dev libxml2-dev

# Copying Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle check || bundle install --jobs 20 --retry 5

# Copy application code
COPY . ./

# Make file executable
RUN chmod +x ./bin/bot

# Run bot
CMD ["bin/bot"]