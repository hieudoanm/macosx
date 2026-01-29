#!/bin/bash

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

  echo -e "🍺🔄 ${BLUE}==> Updating Homebrew...${RESET}"
  brew update

  if [[ $NO_UPGRADE -eq 0 ]]; then
    echo -e "⬆️📦 ${BLUE}==> Upgrading formulae...${RESET}"
    brew upgrade
  else
    echo -e "⏭️😴 ${BLUE}==> Skipping upgrade step${RESET}"
  fi

  echo -e "🧹✨ ${BLUE}==> Cleaning up...${RESET}"
  brew cleanup

  echo -e "✅🎉 ${GREEN}✔ Brew update finished.${RESET}"
}

brew-doctor() {
  echo -e "🩺🔍 ${BLUE}==> Running brew doctor...${RESET}"
  brew doctor || true
  echo -e "🧠✅ ${GREEN}✔ Brew doctor finished.${RESET}"
}

brew-autoremove() {
  echo -e "🗑️📦 ${BLUE}==> Removing unused dependencies...${RESET}"
  brew autoremove
  echo -e "✨✅ ${GREEN}✔ Autoremove completed.${RESET}"
}

brew-update-casks() {
  echo -e "🪟⬆️ ${BLUE}==> Updating casks...${RESET}"
  brew upgrade --cask
  echo -e "🍾✅ ${GREEN}✔ Cask upgrade completed.${RESET}"
}

brew-outdated() {
  echo -e "⏰📦 ${BLUE}==> Outdated formulae:${RESET}"
  brew outdated || true

  echo -e "⏰🪟 ${BLUE}==> Outdated casks:${RESET}"
  brew outdated --cask || true
}

brew-repair() {
  echo -e "🛠️🔎 ${BLUE}==> Checking and repairing brew installation...${RESET}"
  brew missing || true
  brew doctor || true
  brew update-reset
  echo -e "🧯🔧 ${GREEN}✔ Brew repair completed.${RESET}"
}

brew-purge-cache() {
  echo -e "🔥🧹 ${BLUE}==> Purging Homebrew cache...${RESET}"
  brew cleanup -s
  rm -rf "$(brew --cache)"/*
  echo -e "🗑️💨 ${GREEN}✔ Cache purged.${RESET}"
}

brew-space() {
  echo -e "💽📊 ${BLUE}==> Homebrew disk usage:${RESET}"
  du -sh "$(brew --prefix)" 2>/dev/null
  du -sh "$(brew --cache)" 2>/dev/null
}

brew-export() {
  echo -e "📤📜 ${BLUE}==> Exporting Brewfile...${RESET}"
  brew bundle dump --file=~/Brewfile --force
  echo -e "💾✅ ${GREEN}✔ Brewfile saved to ~/Brewfile.${RESET}"
}

### 🐳⚙️ Docker Shortcuts ⚙️🐳 ###

# 📦 List containers / images
alias dps='echo "📦🚢 Running containers:" && docker ps'
alias dpsa='echo "📦🧊 All containers (including stopped):" && docker ps -a'
alias dimg='echo "🖼️🐳 Docker images:" && docker images'

# 🧩 Docker Compose shortcut
alias dc='echo "🧩🐳 Docker Compose" && docker compose'

# 💀 Kill all running containers
alias dkillall='echo "💀🔥 Killing all running containers..." && docker kill $(docker ps -q) 2>/dev/null || echo "😴✨ No containers to kill."'

# 🧹 Remove all stopped containers
alias drmall='echo "🧹📦 Removing all containers..." && \
  CONTAINERS=$(docker ps -aq); \
  [ -n "$CONTAINERS" ] && docker rm -f $CONTAINERS || echo "😴✨ No containers to remove."'

# 🔥 Remove all Docker images
alias drmiall='echo "🔥🖼️ Removing all Docker images..." && \
  IMAGES=$(docker images -q); \
  [ -n "$IMAGES" ] && docker rmi -f $IMAGES || echo "😴✨ No images to remove."'

# 🛑 Stop all containers (safe)
alias dstopall='echo "🛑🚢 Stopping all running containers..." && docker stop $(docker ps -q) 2>/dev/null || echo "😴✨ No containers to stop."'

# 🧽 Remove dangling resources
alias dclean='echo "🧽🧼 Cleaning dangling Docker resources..." && docker system prune -f'

# 💣 Full cleanup: containers, images, networks, volumes, cache
alias dfullclean='echo "💣☢️ FULL Docker cleanup (containers, images, volumes, networks)..." && docker system prune -a --volumes -f'

### 🧬🐙 Git Power Toolkit 🐙🧬 ###

# 🧲 Clone multiple repos
function gcloneall() {
  username="hieudoanm"
  folders=(
    "hieudoanm"
    "hieudoanm.github.io"
  )

  echo "🚀📥 Starting mass clone for user: $username"
  for folder in "${folders[@]}"; do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦➡️  Cloning repo: $folder"
    git clone git@github.com:$username/$folder.git && echo "✅🎉 Clone completed"
  done
  echo "🏁📂 All repositories cloned"
}

# 🌍 Commit everything, everywhere
function gcommitall() {
  if [ -z "$1" ]; then
    echo "❌📝 Usage: gcommitall \"commit message\""
    return 1
  fi

  echo "🚀🌍 Starting recursive Git commit"
  echo "📝💬 Commit message: \"$1\""
  echo "🔍🧭 Scanning for repositories..."
  echo

  find . -type d -name ".git" -exec dirname {} \; | while read -r repo; do
    echo "══════════════════════════════════════"
    echo "📂🧠 Repo found: $repo"
    echo "➡️🚪 Entering repo..."

    (
      cd "$repo" || {
        echo "💥🚫 Failed to enter $repo — skipping"
        exit
      }

      echo "📦➕ Staging all changes..."
      git add -A

      echo "🔎🧪 Checking staged diff..."
      if git diff --cached --quiet; then
        echo "😴🟡 No changes detected"
      else
        echo "✍️🧾 Committing changes..."
        git commit -m "$1" && echo "✅🎯 Commit successful"

        echo "📡⬆️ Pushing to remote..."
        git push && echo "🎉🚀 Push successful"
      fi
    )

    echo "⬅️🚪 Leaving repo"
    echo
  done

  echo "🏁🎊 All repositories processed"
}

# ⬇️🌿 Pull all repos
function gpullall() {
  local branch="${1:-master}"

  echo "========================================"
  echo "🚀⬇️ gpullall started"
  echo "🌿 Target branch: $branch"
  echo "📁 Root directory: $(pwd)"
  echo "========================================"

  find . -type d -name .git -prune -print |
  while read -r gitdir; do
    repo="$(dirname "$gitdir")"

    echo
    echo "----------------------------------------"
    echo "📦📍 Repository: $repo"
    echo "🔀🌿 Branch: $branch"
    echo "----------------------------------------"

    (
      echo "➡️🚪 Entering repository"
      cd "$repo" || {
        echo "❌🚫 cd failed"
        exit 1
      }

      echo "✔️🔁 Checkout branch"
      git checkout "$branch" || exit 1

      echo "⬇️📡 Fetching updates"
      git fetch origin "$branch" || exit 1

      echo "🔄📥 Pulling latest changes"
      git pull origin "$branch" || exit 1

      echo "✅🎉 Repo up-to-date"
    ) || echo "⚠️🔥 Repository failed: $repo"
  done

  echo
  echo "========================================"
  echo "🏁🎯 gpullall finished"
  echo "========================================"
}

# 🌿📍 Current branch
function gcurrent() {
  echo "🌿📍 Current branch: $(git branch | sed -n '/\* /s///p')"
}

# 🏷️🚀 Push tag
function gpushtag() {
  echo "🏷️🚀 Creating & pushing tag: $1"
  git checkout main
  git tag -a $1 -m "v$1"
  git push origin $1
}

# 🏷️🔍 List tags
function gtags() {
  echo "🏷️📜 Matching tags:"
  git tag | grep $1
}

# ❌🏷️ Delete tag
function gdeltag() {
  echo "❌🏷️ Deleting tag: $1"
  git tag -d $1
  git push origin :refs/tags/$1
}

# 🌐⬇️ Fetch branch
function gfetch() {
  echo "🌐⬇️ Fetching branch: $1"
  git fetch --prune origin $1
}

# 🚨⬆️ Force push
function gpushf() {
  BRANCH=$(gcurrent | awk '{print $NF}')
  echo "🚨⬆️ Force pushing branch: $BRANCH"
  git push origin $BRANCH -f
}

# 🌱➕ Create branch
function gbranch() {
  echo "🌱➕ Creating branch: $1"
  git branch $1
  git checkout $1
  git push --set-upstream origin $1
}

# 🗑️🌿 Delete branch
function gdelbranch() {
  echo "🗑️🌿 Deleting branch: $1"
  git branch -d $1
  git branch -D $1
  git push origin -d -f $1
}

# 🧳🔁 Stash + rebase
function gstashrebase() {
  BRANCH=$(git branch | sed -n '/\* /s///p')
  echo "🧳🔁 Rebasing branch: $BRANCH"
  git stash
  git checkout master
  git pull origin master
  git checkout $BRANCH
  git rebase master
  git stash apply
}

# 💣🧹 Hard reset
function greset() {
  echo "💣🧹 Resetting working tree"
  git reset --hard
  git clean -df
}

# 🔁🧬 Rebase branch
function grebase() {
  DEST_BRANCH=$1
  BRANCH=$(git branch | sed -n '/\* /s///p')
  echo "🔁🧬 Rebasing $BRANCH onto $DEST_BRANCH"
  git checkout $DEST_BRANCH
  git pull --rebase origin $DEST_BRANCH
  git checkout $BRANCH
  git rebase $DEST_BRANCH
}

# 🔀🎯 Merge (squash)
function gmerge() {
  DEST_BRANCH=$1
  BRANCH=$(git branch | sed -n '/\* /s///p')
  echo "🔀🎯 Squash merge $BRANCH → $DEST_BRANCH"
  git checkout $DEST_BRANCH
  git merge --squash $BRANCH
  git commit -m "Merge branch $BRANCH"
  git push origin $DEST_BRANCH
}

# 🧼🧠 Clear history
function gclrhst() {
  CURRENT=$(git rev-parse --abbrev-ref HEAD)
  BRANCH=${1:-"$CURRENT"}
  echo "🧼🧠 Clearing history for branch: $BRANCH"

  git checkout --orphan new-$BRANCH
  git add -A
  git commit -m 'initial'
  git branch -D $BRANCH
  git branch -m $BRANCH
  git push -f --set-upstream origin $BRANCH
}

# 🧹🌿 Clear local branches
function gclearbranches() {
  echo "🧹🌿 Removing all local branches except master"
  git branch | grep -v "master" | xargs git branch -D
}

# 🔗🌍 Update remote
function gremoteupdate() {
  echo "🔗🌍 Updating remote origin"
  git remote -v
  git remote set-url origin "$1"
  git remote -v
}

### ⚡ Aliases ⚡ ###
alias ga='git add'
alias gco='git commit -am'
alias gclean='git clean -df'
alias gdh='git diff HEAD'
alias gs='echo "📊 Git status:" && git status'
alias gl='git log --graph --decorate --oneline'
alias gpull='git branch | sed -n "/\* /s///p" | xargs git pull --rebase origin'
alias gpush='git branch | sed -n "/\* /s///p" | xargs git push origin --follow-tags'
alias gb='git branch --sort=-committerdate | head -10'
alias gc='git checkout'
alias gcm='git checkout master'
alias gt='git tag'
alias glog='git log --graph --decorate --oneline'
alias gsetemaillocal='git config --local user.email '
alias gsetnamelocal='git config --local user.name '
alias gsetemailglobal='git config --global user.email '
alias gsetnameglobal='git config --global user.name '

# -------------------------------------
# 🚀🧩 Compact Harness CLI Shortcuts 🧩🚀
# -------------------------------------

alias hrns='harness'   # 🐎 Core Harness CLI

# 🔐 Authentication
hrns-login()     { echo "🔐🚪 Logging into Harness..."; harness login "$@"; }

# 🏢 Organization & Project
hrns-orgs()      { echo "🏢📋 Listing organizations..."; harness org list "$@"; }
hrns-projs()     { echo "📁📋 Listing projects..."; harness project list "$@"; }

# 🚀 Pipelines
hrns-pipes()     { echo "🧪📜 Listing pipelines..."; harness pipeline list "$@"; }
hrns-deploy()    { echo "🚀🔥 Executing pipeline..."; harness pipeline execute "$@"; }
hrns-status()    { echo "📊🔍 Fetching pipeline execution status..."; harness pipeline execution get "$@"; }

# 🌱 Environments
hrns-envs()      { echo "🌱📋 Listing environments..."; harness environment list "$@"; }

# 🔐 Secrets & Connectors
hrns-secrets()   { echo "🔑📜 Listing secrets..."; harness secret list "$@"; }
hrns-connect()   { echo "🔌🌍 Listing connectors..."; harness connector list "$@"; }


# -------------------------------------
# 🧠⚙️ Auto-Completion Helpers
# -------------------------------------

# 🏢 Fetch org identifiers
_hrns_list_orgs() {
  harness org list 2>/dev/null | awk '{print $1}' | tail -n +2
}

# 📁 Fetch project identifiers
_hrns_list_projects() {
  harness project list 2>/dev/null | awk '{print $1}' | tail -n +2
}

# 🧪 Fetch pipeline identifiers
_hrns_list_pipelines() {
  harness pipeline list 2>/dev/null | awk '{print $1}' | tail -n +2
}

# 🌱 Fetch environment identifiers
_hrns_list_envs() {
  harness environment list 2>/dev/null | awk '{print $1}' | tail -n +2
}

# -------------------------------------
# 🧩✨ Auto-Completion Definitions
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
# 🔗🧠 Bind completion to commands
# -------------------------------------

complete -F _hrns_orgs_complete   hrns-orgs     # 🏢
complete -F _hrns_projs_complete  hrns-projs    # 📁
complete -F _hrns_pipes_complete  hrns-pipes    # 🧪
complete -F _hrns_pipes_complete  hrns-deploy   # 🚀
complete -F _hrns_pipes_complete  hrns-status   # 📊
complete -F _hrns_envs_complete   hrns-envs     # 🌱

# -------------------------------------
# 🐚🔁 Zsh Compatibility
# -------------------------------------

if [[ -n "$ZSH_VERSION" ]]; then
  echo "🐚✨ Enabling bash-style completion in zsh..."
  autoload -Uz bashcompinit && bashcompinit
fi

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

# -------------------------------------
# 🌍🧱 Terraform Shortcuts (Compact)
# -------------------------------------

alias tf='terraform'   # 🧱 Core Terraform CLI

# 🚀 Initialization
tf-init() {
  echo "🚀📦 Initializing Terraform..."
  terraform init "$@"
}

# 🧠 Planning
tf-plan() {
  echo "🧠📐 Generating execution plan..."
  terraform plan "$@"
}

# 🛠️ Apply (manual approve)
tf-apply() {
  echo "🛠️🚦 Applying Terraform changes (manual approval)..."
  terraform apply "$@"
}

# ⚡ Apply (auto approve)
tf-apply-auto() {
  echo "⚡🚀 Applying Terraform changes (auto-approve)..."
  terraform apply -auto-approve "$@"
}

# 💣 Destroy (manual approve)
tf-destroy() {
  echo "💣⚠️ Destroying infrastructure (manual approval)..."
  terraform destroy "$@"
}

# ☢️ Destroy (auto approve)
tf-destroy-auto() {
  echo "☢️🔥 Destroying infrastructure (auto-approve)..."
  terraform destroy -auto-approve "$@"
}

# 🧹 Format
tf-fmt() {
  echo "🧹✨ Formatting Terraform files..."
  terraform fmt "$@"
}

# ✅ Validate
tf-validate() {
  echo "✅🔍 Validating Terraform configuration..."
  terraform validate "$@"
}

# 👀 Show
tf-show() {
  echo "👀📄 Showing Terraform state / plan..."
  terraform show "$@"
}

# 🗺️ State
tf-state() {
  echo "🗺️📦 Managing Terraform state..."
  terraform state "$@"
}

# 📤 Outputs
tf-output() {
  echo "📤🔑 Fetching Terraform outputs..."
  terraform output "$@"
}

#
# 🪟➡️🍎 Windows → macOS Command Compatibility Layer
#
# Drop this file into your shell config:
#   source ~/windows-aliases.sh
#
# Provides familiar Windows CLI commands on macOS 💻


### -----------------------------
### 🧹 Basic Terminal Commands
### -----------------------------

# Windows: cls → Clear screen 🧼
alias cls='clear'

# Windows: rst / reset → Reset terminal 🔄
alias rst='reset'


### -----------------------------
### 📁 Files & Directories
### -----------------------------

# dir → ls -al (detailed directory listing 📜)
alias dir='ls -al'

# copy → cp 📄➡️📄
alias copy='cp'

# move → mv 🚚
alias move='mv'

# del / erase → rm ❌
alias del='rm'
alias erase='rm'

# md / mk → mkdir 🏗️
alias md='mkdir'
alias mk='mkdir'

# ren → mv (rename file ✏️)
alias ren='mv'

# type → cat (print file contents 🐱)
alias type='cat'


### -----------------------------
### ⚙️ Processes & System Info
### -----------------------------

# tasklist → ps aux 📊
alias tasklist='ps aux'

# taskkill → kill ☠️
alias taskkill='kill'

# ipconfig → ifconfig 🌐
alias ipconfig='ifconfig'

# hostname → hostname 🏷️
alias hostname='hostname'


### -----------------------------
### 🌍 Network Utilities
### -----------------------------

# ping (same command exists 🏓)
alias ping='ping'

# tracert → traceroute 🧭
alias tracert='traceroute'


### -----------------------------
### ✨ Extra Quality-of-Life Aliases
### -----------------------------

# cls with scrollback reset (optional 🧨)
# alias cls='printf "\033c"'


### -----------------------------
### ⚠️ Safety Notes
### -----------------------------
# These aliases intentionally keep behavior simple 🧠
# If you need more advanced Windows emulation, consider:
#   🍺 Homebrew packages (e.g., cowsay, coreutils)
#   🧩 Installing PowerShell (brew install --cask powershell)


### 🚀 END