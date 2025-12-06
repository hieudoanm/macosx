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
