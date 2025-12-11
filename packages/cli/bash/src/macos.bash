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
  # Auto-detect all directories containing a .git folder (recursive)
  local DIRS
  DIRS=$(find . -type d -name ".git" -exec dirname {} \;)

  echo "🔍 Auto-detected git repos:"
  echo "$DIRS"
  echo

  for dir in $DIRS; do
    echo "-----------------------------------"
    echo "🔄 Processing $dir"
    echo "-----------------------------------"

    cd "$dir" || continue

    git pull origin --rebase
    pnpm update --latest -r

    git add -A
    git commit -m "update packages" || echo "⚠️ No changes to commit"
    git push

    cd - > /dev/null
    echo
  done
}
