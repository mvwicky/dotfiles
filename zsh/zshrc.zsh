#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090,SC1091

profile_startup="${PROFILE_STARTUP-UNSET}"
if [[ $profile_startup != "UNSET" ]]; then
  echo "Profiling startup"
  zmodload zsh/zprof
fi

setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_reduce_blanks

HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=25000
SAVEHIST=25000
HYPHEN_INSENSITIVE="false"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

__has() {
  type "$1" &> /dev/null
}

brew_prefix="/usr/local"
if __has brew; then
  brew_completions=("$brew_prefix/share/zsh/site-functions" "$brew_prefix/share/zsh-completions" "$brew_prefix/opt/curl/share/zsh/site-functions")
  for d in "${brew_completions[@]}"; do
    if [[ -d $d ]]; then
      fpath+=$d
    fi
  done
fi

ASDF_DIR="$HOME/.local/asdf"
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
  export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/.asdfrc"
  export ASDF_DATA_DIR=$ASDF_DIR
  . "$ASDF_DIR/asdf.sh"

  fpath+="$ASDF_DIR/completions"
fi

export ADOTDIR="$XDG_DATA_HOME/antigen"

source "$brew_prefix/opt/antigen/share/antigen/antigen.zsh"
antigen init "$HOME/.antigenrc"

# Init pyenv
if __has pyenv; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

if [[ -n $ZSH_FOLDER ]]; then
  funcs="$ZSH_FOLDER/functions.zsh"
  aliases_file="$ZSH_FOLDER/alias.zsh"
  # Load functions and aliases
  test -f "$funcs" && source "$funcs"
  test -f "$aliases_file" && source "$aliases_file"
  unset funcs
  unset aliases_file
  export ZSH_FOLDER
fi

if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ]]; then
  if __has fd; then
    export FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude '.git'"
  fi
  source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
fi

eval "$(direnv hook zsh)"

if [[ -f "${HOME}/startup.py" ]]; then
  export PYTHONSTARTUP="${HOME}/startup.py"
fi

if __has luarocks; then
  eval "$(luarocks path --no-bin)"
fi

# shellcheck disable=SC2155
export GPG_TTY="$(tty)"

# Wasmer
export WASMER_DIR="/Users/michael/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh" # This loads wasmer

export NODE_VERSION_PREFIX=""
export NODE_VERSIONS="$NVM_DIR/versions/node"
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/.node_repl_history"
export NODE_REPL_HISTORY_SIZE=2000
export TS_NODE_HISTORY="$XDG_CACHE_HOME/.ts_node_repl_history"

eval "$(fnm env --use-on-cd)"

# tabtab source for packages
# uninstall by removing these lines
[ -f "$HOME/.config/tabtab/zsh/__tabtab.zsh" ] && source "$HOME/.config/tabtab/zsh/__tabtab.zsh"

eval "$(starship init zsh)"

if [[ $profile_startup != "UNSET" ]]; then
  zprof
  zmodload -u zsh/zprof
fi
