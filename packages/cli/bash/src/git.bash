#!/bin/bash

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
