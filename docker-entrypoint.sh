#!/bin/sh
set -e

# Wait for the database to be ready
while ! nc -z $DB_HOST $DB_PORT; do
  echo "Waiting for database to be ready..."
  sleep 2
done

# Run database migrations
bundle exec rake db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
