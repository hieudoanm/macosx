#!/bin/bash

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
