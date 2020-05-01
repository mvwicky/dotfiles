#!/usr/bin/env bash

alias dj="poetry run python manage.py"
alias p="poetry"
alias py="python"
alias pym="python manage.py"
alias pup='pip install -U pip setuptools wheel'
alias pupx="pip install -U pip setuptools wheel pipx"
alias pip-old="pip list --outdated"
alias pupdate='poetry update'
alias pold='poetry show --outdated'

alias ga="git add"
alias gp="git push"
alias gc="git commit"
alias st='git status'

alias nyarn="nvm use && yarn"
alias pad="poetry add --dev"
alias pa="poetry add"
alias prg="ps -ex | rg --context=0"
# alias print_path="python -c \"import os; print('\n'.join(os.environ['PATH'].split(os.pathsep)))\""
# alias ls="colorls --light --sort-dirs --report -1la"
alias ycount="yarn --silent list --depth 0 --json | jq '[.data.trees[].name] | length'"
if command -v exa 1> /dev/null 2>&1; then
  alias l="exa -lah"
  alias ll="exa -lah"
else
  alias l="ls -lah"
  alias ll="ls -lah"
fi
alias pout='poetry show --outdated; yarn outdated'
if command -v gmake 1> /dev/null 2>&1; then
  alias make='gmake'
fi
alias zshconfig='${EDITOR} ~/.zshrc'
alias dustr='dust -r'

alias ffprh='ffprobe -hide_banner'
alias ffmrh='ffmpeg -hide_banner'
alias px='pipxr'
