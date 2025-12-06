#!/bin/bash

# --- Heroku Helpers ---

# Tail logs
heroku-logs() {
  if [ -z "$1" ]; then
    echo "Usage: heroku-logs <app-name>"
    return 1
  fi
  heroku logs --tail --app "$1"
}

# Open app in browser
heroku-open() {
  if [ -z "$1" ]; then
    echo "Usage: heroku-open <app-name>"
    return 1
  fi
  heroku apps:open --app "$1"
}

# Restart dyno(s)
heroku-restart() {
  if [ -z "$1" ]; then
    echo "Usage: heroku-restart <app-name>"
    return 1
  fi
  heroku ps:restart web.1 --app "$1"
}
