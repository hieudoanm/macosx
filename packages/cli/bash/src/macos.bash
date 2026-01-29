#!/bin/bash

# 🍎💻 macOS Helpers

# -------------------------------------
# 🌱 Environment
# -------------------------------------

function print-env() {
  echo "🌍📦 Printing environment variables (sorted)..."
  lines=$(printenv)
  IFS=$'\n' sorted=$(sort <<< "${lines[*]}")
  unset IFS
  printf "%s" "${sorted[@]}"
}

# -------------------------------------
# 🧹 Utilities
# -------------------------------------

alias delete-ds-store='echo "🧹🗑️ Deleting .DS_Store files..." && find . -name ".DS_Store" -delete'
alias kill-port='echo "💀🔌 Killing process on port:" && sudo lsof -i tcp:'
alias hex='echo "🔐🎲 Generating random hex..." && openssl rand -hex 32'

# -------------------------------------
# 📦 Package / Workspace Helpers
# -------------------------------------

list_packages() {
  echo "📦🗂️ Scanning for package folders..."
  for d in */; do
    if [[ -d "$d/packages" ]]; then
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "📁 $d"
      find "$d/packages" -mindepth 1 -maxdepth 1 -type d | sort
      echo
    fi
  done
}

# -------------------------------------
# 🔄🌍 Update All Repositories
# -------------------------------------

update_repos() {
  echo "🔍🌍 Scanning deeply for git repositories..."
  echo "📍 Root: $(pwd)"
  echo

  local root
  root="$(pwd)"

  find "$root" \
    -type d -name ".git" \
    -not -path "*/.git/*" \
    -print0 |
  while IFS= read -r -d '' gitdir; do
    dir="$(dirname "$gitdir")"

    echo "══════════════════════════════════════"
    echo "📂🔄 Processing repository:"
    echo "➡️  $dir"
    echo "══════════════════════════════════════"

    if [ ! -d "$dir" ]; then
      echo "❌🚫 Skipping (directory no longer exists)"
      continue
    fi

    (
      cd "$dir" || exit 0

      echo "🧠🔎 Validating git repository..."
      git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
        echo "⚠️🧪 Not a valid git repository"
        exit 0
      }

      echo "⬇️🔁 Pulling latest changes (rebase)..."
      git pull origin --rebase

      if [ -f "pnpm-workspace.yaml" ] || [ -d "node_modules" ]; then
        echo "📦⬆️ Updating pnpm packages (recursive, latest)..."
        pnpm update --latest -r
      else
        echo "📦😴 No pnpm workspace detected"
      fi

      echo "➕📂 Staging changes..."
      git add -A

      echo "✍️📝 Committing updates..."
      git commit -m "update packages" 2>/dev/null \
        || echo "⚠️😴 No changes to commit"

      echo "📡⬆️ Pushing to remote..."
      git push
    )

    echo "⬅️🚪 Done with repo"
    echo
  done

  echo "🏁🎉 Repository update sweep completed"
}

# -------------------------------------
# 📋📎 Clipboard Helper
# -------------------------------------

clipboard() {
  local content

  echo "📋🔍 Reading clipboard..."

  if command -v pbpaste >/dev/null; then
    echo "🍎 Using pbpaste"
    content="$(pbpaste)"
  elif command -v wl-paste >/dev/null; then
    echo "🐧 Using wl-paste"
    content="$(wl-paste)"
  elif command -v xclip >/dev/null; then
    echo "🧪 Using xclip"
    content="$(xclip -selection clipboard -o)"
  else
    echo "❌🚫 Clipboard tool not found" >&2
    return 2
  fi

  [[ -n "$content" ]] || {
    echo "⚠️📭 Clipboard is empty"
    return 1
  }

  printf "%s" "$content"
}

# -------------------------------------
# 🧭 Navigation
# -------------------------------------

alias back='echo "⬅️📁 Going back..." && cd ..'
alias home='echo "🏠📁 Going home..." && cd ~'
