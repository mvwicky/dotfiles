#!/usr/bin/env bash

alias dj="poetry run python manage.py"
alias p="poetry"
alias py="python"
alias pym="python manage.py"
alias pup='python -m pip install -U pip setuptools wheel'
alias pupx='python -m pip install -U pip setuptools wheel pipx'
alias pip-old='pip list --outdated'
alias pold='poetry show --outdated'
alias sm='smerge $PWD'

alias ga="git add"
alias gp="git push --verbose"
alias gc="git commit"
alias st='git status'

alias yas="yarn --silent"
alias yc="yarn config"
alias ygui="yarn global upgrade-interactive"
alias cdygdir='cd "$(yg dir)"'
alias pa="poetry add"

alias ycount="yarn --silent list --depth 0 --json | jq '[.data.trees[].name] | length'"
if command -v eza 1> /dev/null 2>&1; then
  alias l="eza -lah"
  alias ll="eza -lah"
  alias lg="eza -lah --git"
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
alias tra='trash'
alias activate-venv='source .venv/bin/activate'
