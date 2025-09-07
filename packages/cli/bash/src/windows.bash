#!/bin/bash
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
