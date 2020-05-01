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
export CARGO_BUILD_JOBS=2

export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/flutter/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$PATH:$HOME/.poetry/bin"
export PATH="$HOME/.local/bin:$PATH"

export BUNDLEFILE="$HOME/Dropbox/Brewfile"

# export NVM_LAZY_LOAD=true
export MYPYPATH="$HOME/Dropbox/Code/Stubs"

export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/.ripgreprc"
export APP_SUPPORT="$HOME/Library/Application Support"
export SUBL_DATA="$APP_SUPPORT/Sublime Text 3"

# export BAT_PAGER="less -R"
