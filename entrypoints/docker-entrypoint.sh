#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Create database if it doesn't exist and run migrations
bundle exec rake db:create 2>/dev/null || true
bundle exec rake db:migrate 2>/dev/null || true

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
