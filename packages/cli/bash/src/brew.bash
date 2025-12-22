#!/usr/bin/env bash

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RESET="\033[0m"

brew-update() {
  local NO_UPGRADE=0

  # Parse flags
  for arg in "$@"; do
    case "$arg" in
      --no-upgrade) NO_UPGRADE=1 ;;
    esac
  done

  echo -e "${BLUE}==> Updating Homebrew...${RESET}"
  brew update

  if [[ $NO_UPGRADE -eq 0 ]]; then
    echo -e "${BLUE}==> Upgrading formulae...${RESET}"
    brew upgrade
  else
    echo -e "${BLUE}==> Skipping upgrade step${RESET}"
  fi

  echo -e "${BLUE}==> Cleaning up...${RESET}"
  brew cleanup

  echo -e "${GREEN}✔ Brew update finished.${RESET}"
}

# Example usage:
#   brew-update
#   brew-update --no-upgrade

brew-doctor() {
  echo -e "${BLUE}==> Running brew doctor...${RESET}"
  brew doctor || true
  echo -e "${GREEN}✔ Brew doctor finished.${RESET}"
}

brew-autoremove() {
  echo -e "${BLUE}==> Removing unused dependencies...${RESET}"
  brew autoremove
  echo -e "${GREEN}✔ Autoremove completed.${RESET}"
}

brew-update-casks() {
  echo -e "${BLUE}==> Updating casks...${RESET}"
  brew upgrade --cask
  echo -e "${GREEN}✔ Cask upgrade completed.${RESET}"
}

brew-outdated() {
  echo -e "${BLUE}==> Outdated formulae:${RESET}"
  brew outdated || true

  echo -e "${BLUE}==> Outdated casks:${RESET}"
  brew outdated --cask || true
}

brew-repair() {
  echo -e "${BLUE}==> Checking and repairing brew installation...${RESET}"
  brew missing || true
  brew doctor || true
  brew update-reset
  echo -e "${GREEN}✔ Brew repair completed.${RESET}"
}

brew-purge-cache() {
  echo -e "${BLUE}==> Purging Homebrew cache...${RESET}"
  brew cleanup -s
  rm -rf "$(brew --cache)"/*
  echo -e "${GREEN}✔ Cache purged.${RESET}"
}

brew-space() {
  echo -e "${BLUE}==> Homebrew disk usage:${RESET}"
  du -sh "$(brew --prefix)" 2>/dev/null
  du -sh "$(brew --cache)" 2>/dev/null
}

brew-export() {
  echo -e "${BLUE}==> Exporting Brewfile...${RESET}"
  brew bundle dump --file=~/Brewfile --force
  echo -e "${GREEN}✔ Brewfile saved to ~/Brewfile.${RESET}"
}
