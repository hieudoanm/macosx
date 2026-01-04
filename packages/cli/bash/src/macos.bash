#!/bin/bash

# MacOS

# Brew

function print-env() {
  lines=$(printenv);
  IFS=$'\n' sorted=$(sort <<< "${lines[*]}");
  unset IFS;
  printf "%s" "${sorted[@]}";
}

alias delete-ds-store="find . -name ".DS_Store" -delete"
alias kill-port='sudo lsof -i tcp:'
alias hex='openssl rand -hex 32'

list_packages() {
  for d in */; do
    if [[ -d "$d/packages" ]]; then
      echo "[$d]"
      find "$d/packages" -mindepth 1 -maxdepth 1 -type d | sort
      echo
    fi
  done
}

update_repos() {
  echo "🔍 Scanning deeply for git repositories..."

  local root
  root="$(pwd)"

  find "$root" \
    -type d -name ".git" \
    -not -path "*/.git/*" \
    -print0 |
  while IFS= read -r -d '' gitdir; do
    dir="$(dirname "$gitdir")"

    echo "-----------------------------------"
    echo "🔄 Processing: $dir"
    echo "-----------------------------------"

    if [ ! -d "$dir" ]; then
      echo "❌ Skipping (directory no longer exists)"
      continue
    fi

    (
      cd "$dir" || exit 0

      # Ensure it's a real git repo
      git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
        echo "⚠️ Not a valid git repository"
        exit 0
      }

      git pull origin --rebase

      if [ -f "pnpm-workspace.yaml" ] || [ -d "node_modules" ]; then
        pnpm update --latest -r
      fi

      git add -A
      git commit -m "update packages" 2>/dev/null \
        || echo "⚠️ No changes to commit"

      git push
    )

    echo
  done
}

clipboard() {
  local content

  if command -v pbpaste >/dev/null; then
    content="$(pbpaste)"
  elif command -v wl-paste >/dev/null; then
    content="$(wl-paste)"
  elif command -v xclip >/dev/null; then
    content="$(xclip -selection clipboard -o)"
  else
    echo "❌ Clipboard tool not found" >&2
    return 2
  fi

  [[ -n "$content" ]] || return 1
  printf "%s" "$content"
}

alias back="cd .."
alias home="cd ~"
