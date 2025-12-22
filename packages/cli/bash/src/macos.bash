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
  echo "🔍 Scanning for git repos..."

  find . -type d -name ".git" -exec dirname {} \; \
    | sort -f \
    | while IFS= read -r dir; do

      echo "-----------------------------------"
      echo "🔄 Processing: $dir"
      echo "-----------------------------------"

      if [ ! -d "$dir" ]; then
        echo "❌ Skipping (directory no longer exists): $dir"
        continue
      fi

      cd "$dir" || continue

      git pull origin --rebase
      pnpm update --latest -r

      git add -A
      git commit -m "update packages" 2>/dev/null || echo "⚠️ No changes to commit"
      git push

      cd - > /dev/null
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
