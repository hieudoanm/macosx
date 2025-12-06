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
