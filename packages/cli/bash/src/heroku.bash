#!/bin/bash

# -------------------------------------
# 🚀📡 Heroku Helpers (with logs)
# -------------------------------------

# 🧾 Tail logs
heroku-logs() {
  if [ -z "$1" ]; then
    echo "❌ Usage: heroku-logs <app-name>"
    return 1
  fi

  echo "📡🧾 [$(date '+%Y-%m-%d %H:%M:%S')] Tailing logs"
  echo "🏷️  App: $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  heroku logs --tail --app "$1"
}

# 🌍 Open app in browser
heroku-open() {
  if [ -z "$1" ]; then
    echo "❌ Usage: heroku-open <app-name>"
    return 1
  fi

  echo "🌍🚀 [$(date '+%Y-%m-%d %H:%M:%S')] Opening app in browser"
  echo "🏷️  App: $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  heroku apps:open --app "$1"
}

# 🔁 Restart dyno(s)
heroku-restart() {
  if [ -z "$1" ]; then
    echo "❌ Usage: heroku-restart <app-name>"
    return 1
  fi

  echo "🔁⚙️  [$(date '+%Y-%m-%d %H:%M:%S')] Restarting dyno"
  echo "🏷️  App: $1"
  echo "🧠 Dyno: web.1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  heroku ps:restart web.1 --app "$1" && \
    echo "✅🎉 Dyno restarted successfully"
}
