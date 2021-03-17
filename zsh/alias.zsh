#!/usr/bin/env bash

alias dj="poetry run python manage.py"
alias p="poetry"
alias py="python"
alias pym="python manage.py"
alias pup='pip install -U pip setuptools wheel'
alias pupx='pip install -U pip setuptools wheel pipx'
alias pip-old='pip list --outdated'
alias pold='poetry show --outdated'
alias sm='smerge $PWD'
alias nvm-ls='nvm ls --no-alias'

alias ga="git add"
alias gp="git push --verbose"
alias gc="git commit"
alias st='git status'

alias yas="yarn --silent"
alias yc="yarn config"
alias pa="poetry add"
alias pad="poetry add --dev"
alias prg="ps -exf | rg --context=0 --no-stats"

alias ycount="yarn --silent list --depth 0 --json | jq '[.data.trees[].name] | length'"
if command -v exa 1> /dev/null 2>&1; then
  alias l="exa -lah"
  alias ll="exa -lah"
  alias lg="exa -lah --git"
else
  alias l="ls -lah"
  alias ll="ls -lah"
fi

if command -v gmake 1> /dev/null 2>&1; then
  alias make='gmake'
fi

alias zshconfig='${EDITOR} ~/.zshrc'
alias histedit='${EDITOR} ~/.zsh_history'
alias dustr='dust -r'

alias ffprobe='ffprobe -hide_banner'
alias ffmpeg='ffmpeg -hide_banner'
alias px='pipxr'
alias batt='bat --terminal-width=$(tput cols)'
alias yupl='yarn upgrade -L'
alias yg='yarn global'
alias g='git'
