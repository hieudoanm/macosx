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
