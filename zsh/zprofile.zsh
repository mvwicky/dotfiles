#!/usr/bin/env bash
# shellcheck disable=SC2148

__has() {
  type "$1" &> /dev/null
}

# shellcheck disable=2162,2034,2207,1087,2211,2086
function _pip_completion() {
  local words cword
  read -Ac words
  read -cn cword
  reply=($(COMP_WORDS="$words[*]" \
    COMP_CWORD=$((cword - 1)) \
    PIP_AUTO_COMPLETE=1 $words[1] 2> /dev/null))
}
compctl -K _pip_completion pip

export PATH="$HOME/bin/yarn/bin:$PATH"
export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
# export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"

if [[ -f /usr/local/bin/nvim ]]; then
  export EDITOR='/usr/local/bin/nvim'
fi

export PYENV_VIRTUALENV_VERBOSE_ACTIVATE=1

# Init pyenv
if command -v pyenv 1> /dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

if __has gmake; then
  export MAKE=gmake
fi

if __has sccache; then
  export SCCACHE_CACHE_SIZE="2G"
  # export SCCACHE_REDIS='redis://127.0.0.1:6379/10'
  export RUSTC_WRAPPER=sccache
fi

if [[ -n $ZSH_FOLDER ]]; then
  if [[ -d "$ZSH_FOLDER/bin" ]]; then
    export PATH="$ZSH_FOLDER/bin:$PATH"
  fi
fi
