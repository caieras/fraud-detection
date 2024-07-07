FROM ruby:3.3.3 AS base

ENV RUBY_YJIT_ENABLE=1
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application
COPY . .

# Copy the entrypoint script
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

EXPOSE 9292

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "9292"]
