#!/bin/bash
set -e

echo "Starting entrypoint script..."

# Wait for PostgreSQL to be ready
until pg_isready -h "$DATABASE_HOST" -U "$DATABASE_USER"; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is up - executing commands..."

# Debugging: Print environment variables
echo "DATABASE_HOST: $DATABASE_HOST"
echo "DATABASE_USER: $DATABASE_USER"

# Ensure the database is created
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Execute the main container command (passed as arguments to this script)
echo "Executing command: $@"
exec "$@"
