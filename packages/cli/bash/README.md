# Bash

```bash
curl -fsSL https://raw.githubusercontent.com/hieudoanm/bash/master/install.sh | bash
```

## brew

```bash
#!/usr/bin/env bash
set -eo pipefail

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
```

## docker

```bash
#!/bin/bash

### Docker Shortcuts ###

# List containers / images
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'

# Docker Compose shortcut
alias dc='docker compose'

# Kill all running containers
alias dkillall='docker kill $(docker ps -q) 2>/dev/null || echo "No containers to kill."'

# Remove all stopped containers
alias drmall='CONTAINERS=$(docker ps -aq); \
  [ -n "$CONTAINERS" ] && docker rm -f $CONTAINERS || echo "No containers to remove."'

# Remove all Docker images
alias drmiall='IMAGES=$(docker images -q); \
  [ -n "$IMAGES" ] && docker rmi -f $IMAGES || echo "No images to remove."'

# Stop all containers (safe version)
alias dstopall='docker stop $(docker ps -q) 2>/dev/null || echo "No containers to stop."'

# Remove dangling resources
alias dclean='docker system prune -f'

# Full cleanup: containers, images, networks, build cache
alias dfullclean='docker system prune -a --volumes -f'
```

## git

```bash
#!/bin/bash

# Git

function gcloneall() {
  username="hieudoanm"
  folders=(
    "hieudoanm"
    "hieudoanm.github.io"
  )
  for folder in "${folders[@]}"
  do
    echo "----- $folder -----";
    git clone git@github.com:$username/$folder.git
  done
}

function gcommitall() {
  for folder in $(ls -d */)
  do
    if [ -d "$folder" ]; then
        echo "----- $folder -----";
        cd $folder;
        git add -A;
        git status;
        git commit -m '$1';
        git push
        cd ..;
    fi
  done
}

function gpullall() {
  for folder in $(ls -d */)
  do
    if [ -d "$folder" ]; then
      echo "----- $folder -----";
      cd $folder;
      git checkout master;
      git fetch origin master;
      git pull origin master;
      cd ..;
    fi
  done
}

function gcurrent() {
  echo `git branch | sed -n '/\* /s///p'`
}

# gpushtag <tag-name>
function gpushtag() {
  git checkout main
  git tag -a $1 -m 'v$1'
  git push origin $1
}

# gtags <filter-string>
function gtags() {
  TAGS=`git tag | grep $1`
  echo $TAGS
}

# gtagdelete <branch-name>
function gdeltag() {
  git tag -d $1
  git push origin :refs/tags/$1
}

# gfetch <branch-name>
function gfetch() {
  git fetch --prune origin $1
}

# gpull <branch-name>
# function gpull() {
#   git pull --prune origin $1
# }

# gpush <branch-name>
# function gpush() {
#   BRANCH=$(gcurrent)
#   echo 'Current git branch $BRANCH'
#   git push origin $BRANCH
# }

# gpushf <branch-name>
function gpushf() {
  BRANCH=$(gcurrent)
  echo "Current git branch $BRANCH"
  git push origin $BRANCH -f
}

# gbranch <branch-name>
function gbranch() {
  git branch $1
  git checkout $1
  git push --set-upstream origin $1
}

# gdelbranch <branch-name>
function gdelbranch() {
  git branch -d $1
  git branch -D $1
  git push origin -d -f $1
}

# gstashrebase
function gstashrebase() {
  BRANCH=$(gcurrent)
  echo "Current git branch $BRANCH"
  git stash
  git checkout master
  git pull origin master
  git checkout $BRANCH
  git rebase master
  git stash apply
}

# greset
function greset() {
  git reset --hard
  git clean -df
}

# grebase <branch-name>
function grebase() {
  DEST_BRANCH=$1
  BRANCH=$(gcurrent)
  git checkout $DEST_BRANCH
  git pull --rebase origin $DEST_BRANCH
  git checkout $BRANCH
  git rebase $DEST_BRANCH
}

# gmerge <branch-name>
function gmerge() {
  DEST_BRANCH=$1
  BRANCH=$(gcurrent)
  git checkout $DEST_BRANCH
  git merge --squash $BRANCH
  git commit -m "Merge branch $BRANCH"
  git push origin $DEST_BRANCH
}

# gclrhst <branch-name>
function gclrhst() {
  CURRENT=$(git rev-parse --abbrev-ref HEAD)
  echo $CURRENT
  BRANCH=${1:-"$CURRENT"}
  echo $BRANCH
  git checkout --orphan new-$BRANCH # create a temporary branch
  git add -A  # Add all files and commit them
  git commit -m 'initial'
  git branch -D $BRANCH # Deletes the master branch
  git branch -m $BRANCH # Rename the current branch to master
  git push -f --set-upstream origin $BRANCH # Force push master branch to Git server
}

# gclearbranches
function gclearbranches() {
  git branch | grep -v "master" | xargs git branch -D
}

# gremoteupdate
function gremoteupdate() {
  git remote -v
  git remote set-url origin "$1"
  git remote -v
}

# Aliases for git commands
alias ga='git add'
alias gco='git commit -am'
alias gclean="git clean -df"
alias gdh="git diff HEAD"
alias gs="git status"
alias gl="git log --graph --decorate --oneline"
alias gpull='git branch | sed -n "/\* /s///p" | xargs git pull --rebase origin'
alias gsall="find /path/to/project -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;"
alias gpush='git branch | sed -n "/\* /s///p" | xargs git push origin --follow-tags'
alias gb='git branch --sort=-committerdate | head -10'
alias gc='git checkout'
alias gcm='git checkout master'
alias gt='git tag'
alias gpushdocker='/usr/local/bin/tag-increment && git branch | sed -n "/\* /s///p" | xargs git push origin --follow-tags'
alias glog="git log --graph --decorate --oneline"
alias gsetemaillocal="git config --local user.email "
alias gsetnamelocal="git config --local user.name "
alias gsetemailglobal="git config --global user.email "
alias gsetnameglobal="git config --global user.name "
```

## harness

```bash
#!/bin/bash

# -------------------------------------
# Compact Harness CLI Shortcuts
# -------------------------------------

alias hrns='harness'

hrns-login()     { harness login "$@"; }
hrns-orgs()      { harness org list "$@"; }
hrns-projs()     { harness project list "$@"; }
hrns-pipes()     { harness pipeline list "$@"; }
hrns-deploy()    { harness pipeline execute "$@"; }
hrns-status()    { harness pipeline execution get "$@"; }
hrns-envs()      { harness environment list "$@"; }
hrns-secrets()   { harness secret list "$@"; }
hrns-connect()   { harness connector list "$@"; }


# -------------------------------------
# Auto-Completion Helpers
# -------------------------------------

# Pull a list of values using Harness CLI, output only the names
_hrns_list_orgs() {
  harness org list 2>/dev/null | awk '{print $1}' | tail -n +2
}

_hrns_list_projects() {
  harness project list 2>/dev/null | awk '{print $1}' | tail -n +2
}

_hrns_list_pipelines() {
  harness pipeline list 2>/dev/null | awk '{print $1}' | tail -n +2
}

_hrns_list_envs() {
  harness environment list 2>/dev/null | awk '{print $1}' | tail -n +2
}

# -------------------------------------
# Auto-Completion Definitions
# -------------------------------------

_hrns_orgs_complete() {
  COMPREPLY=( $(compgen -W "$(_hrns_list_orgs)" -- "${COMP_WORDS[COMP_CWORD]}") )
}

_hrns_projs_complete() {
  COMPREPLY=( $(compgen -W "$(_hrns_list_projects)" -- "${COMP_WORDS[COMP_CWORD]}") )
}

_hrns_pipes_complete() {
  COMPREPLY=( $(compgen -W "$(_hrns_list_pipelines)" -- "${COMP_WORDS[COMP_CWORD]}") )
}

_hrns_envs_complete() {
  COMPREPLY=( $(compgen -W "$(_hrns_list_envs)" -- "${COMP_WORDS[COMP_CWORD]}") )
}

# -------------------------------------
# Bind completion to functions
# -------------------------------------

complete -F _hrns_orgs_complete   hrns-orgs
complete -F _hrns_projs_complete  hrns-projs
complete -F _hrns_pipes_complete  hrns-pipes
complete -F _hrns_pipes_complete  hrns-deploy
complete -F _hrns_pipes_complete  hrns-status
complete -F _hrns_envs_complete   hrns-envs

# Zsh compatibility
if [[ -n "$ZSH_VERSION" ]]; then
  autoload -Uz bashcompinit && bashcompinit
fi
```

## heroku

```bash
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
```

## macos

```bash
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
```

## terraform

```bash
#!/bin/bash

# Terraform Shortcuts (Compact)

alias tf='terraform'

tf-init()      { terraform init "$@"; }
tf-plan()      { terraform plan "$@"; }
tf-apply()     { terraform apply "$@"; }
tf-apply-auto(){ terraform apply -auto-approve "$@"; }
tf-destroy()   { terraform destroy "$@"; }
tf-destroy-auto(){ terraform destroy -auto-approve "$@"; }
tf-fmt()       { terraform fmt "$@"; }
tf-validate()  { terraform validate "$@"; }
tf-show()      { terraform show "$@"; }
tf-state()     { terraform state "$@"; }
tf-output()    { terraform output "$@"; }
```

## windows

```bash
#!/bin/bash
#
# Windows → macOS Command Compatibility Layer
#
# Drop this file into your shell config:
#   source ~/windows-aliases.sh
#
# Provides familiar Windows CLI commands on macOS.


### -----------------------------
###  Basic Terminal Commands
### -----------------------------

# Windows: cls → Clear screen
alias cls='clear'

# Windows: rst / reset → Reset terminal
alias rst='reset'


### -----------------------------
###  Files & Directories
### -----------------------------

# dir → ls -al (detailed directory listing)
alias dir='ls -al'

# copy → cp
alias copy='cp'

# move → mv
alias move='mv'

# del / erase → rm
alias del='rm'
alias erase='rm'

# md / mk → mkdir
alias md='mkdir'
alias mk='mkdir'

# ren → mv (rename file)
alias ren='mv'

# type → cat (print file contents)
alias type='cat'


### -----------------------------
###  Processes & System Info
### -----------------------------

# tasklist → ps aux
alias tasklist='ps aux'

# taskkill → kill
alias taskkill='kill'

# ipconfig → ifconfig (network info)
alias ipconfig='ifconfig'

# hostname → hostname (same command exists but included for completeness)
alias hostname='hostname'


### -----------------------------
###  Network Utilities
### -----------------------------

# ping (same command exists)
alias ping='ping'

# tracert → traceroute
alias tracert='traceroute'


### -----------------------------
###  Extra Quality-of-Life Aliases
### -----------------------------

# cls with scrollback reset (optional)
# alias cls='printf "\033c"'


### -----------------------------
###  Safety Notes
### -----------------------------
# These aliases intentionally keep behavior simple.
# If you need more advanced Windows emulation, consider:
#   - Homebrew packages (e.g., cowsay, coreutils)
#   - Installing PowerShell (brew install --cask powershell)


### END
```