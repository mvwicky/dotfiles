#!/usr/bin/env bash

setopt PROMPT_SUBST

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/Library/Caches/TemporaryItems"

export PYENV_ROOT="$HOME/.pyenv"
export NVIM_LOG_FILE="$HOME/.local/share/nvim/nvim.log"

export GOPATH="$XDG_DATA_HOME"/go
export DENO_INSTALL_ROOT="$XDG_DATA_HOME"/deno

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
# export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$DENO_INSTALL_ROOT/bin:$PATH"

export BUNDLEFILE="$HOME/Developer/GitHub/dotfiles/Brewfile"
export HOMEBREW_BUNDLE_FILE=$BUNDLEFILE
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=60
export HOMEBREW_DISPLAY_INSTALL_TIMES=1
export HOMEBREW_NO_ENV_HINTS=1
export EGET_CONFIG="$XDG_CONFIG_HOME/eget.toml"
export PATH="$HOME/bin/eget:$PATH"

export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('cd')

export MYPYPATH="$HOME/Dropbox/Code/Stubs"

export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="g _"

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"
export APPS="/Applications"
export APP_SUPPORT="$HOME/Library/Application Support"
export SUBL_DATA="$APP_SUPPORT/Sublime Text 3"

export CONDARC="$XDG_CONFIG_HOME/.condarc"
export DENO_DIR="$XDG_CACHE_HOME/deno"
export DENO_INSTALL="$XDG_DATA_HOME/deno"

export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/pycache"

export BAT_PAGER='less -RXF -Ps?P%Pb:.\:'
# export LESS='-R -Ps?P%Pb:.\:'
# export BAT_PAGER='less -FXRm'

export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export ANDROID_HOME="$XDG_DATA_HOME"/android
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RYE_HOME="$XDG_DATA_HOME"/rye

export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME"/platformio
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

export REDISCLI_HISTFILE="${XDG_CACHE_HOME}/rediscli_history"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history

export PATH="$RYE_HOME/shims:$PATH"

# shellcheck disable=SC2034
DROPBOX_ZSH="${HOME}/Dropbox/config/zsh"
# shellcheck disable=SC2034
ZSH_FOLDER="${HOME}/Developer/GitHub/dotfiles/zsh"
# See: https://github.com/pyenv/pyenv/tree/master/plugins/python-build
# export PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto'
# export PYTHON_CFLAGS='--march-native -mtune=native'
