#!/usr/bin/env bash

setopt PROMPT_SUBST

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR=nvim
export PYENV_ROOT="$HOME/.pyenv"
export NVIM_LOG_FILE="$HOME/.local/nvim/share/log"
# export CARGO_BUILD_JOBS=1

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/flutter/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.poetry/bin"

export BUNDLEFILE="$HOME/Dropbox/config/Brewfile"
export HOMEBREW_BUNDLE_FILE=$BUNDLEFILE

export NVM_DIR="$XDG_CONFIG_HOME/nvm"
# export NVM_LAZY_LOAD="${NVM_LAZY_LOAD:-true}"
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('cd')

export MYPYPATH="$HOME/Dropbox/Code/Stubs"

export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="g _"

export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/.ripgreprc"
export APP_SUPPORT="$HOME/Library/Application Support"
export SUBL_DATA="$APP_SUPPORT/Sublime Text 3"

export CONDARC="$XDG_CONFIG_HOME/.condarc"
export DENO_DIR="$XDG_CACHE_HOME/deno"
export DENO_INSTALL="$XDG_DATA_HOME/deno"

export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/pycache"

# export LESS='-R -Ps?P%Pb:.\:'
export BAT_PAGER='less -RXF -Ps?P%Pb:.\:'
# export BAT_PAGER='less -FXRm'

# shellcheck disable=SC2034
DROPBOX_ZSH="${HOME}/Dropbox/config/zsh"
