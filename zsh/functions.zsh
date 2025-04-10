#!/usr/bin/env bash

ZSH_FOLDER="${HOME}/Developer/GitHub/dotfiles/zsh"

has() {
  type "$1" &>/dev/null
}

echo_stderr() {
  echo "$@" >&2
}

print_and_execute() {
  echo "+" "$@" >&2
  "$@"
}

man() {
  # Shows pretty `man` page.
  local reset
  reset="$(tput sgr0)"
  local bold
  bold="$(tput bold)"
  local red
  red="$(tput setaf 1)"
  local green
  green="$(tput setaf 2)"
  local yellow
  yellow="$(tput setaf 3)"
  local blue
  blue="$(tput setaf 4)"
  local uline
  uline="$(tput smul)"
  env \
    LESS_TERMCAP_mb="$bold$red" \
    LESS_TERMCAP_md="$bold$red" \
    LESS_TERMCAP_me="$reset" \
    LESS_TERMCAP_so="$bold$yellow$blue" \
    LESS_TERMCAP_se="$reset" \
    LESS_TERMCAP_us="$bold$uline$green" \
    LESS_TERMCAP_ue="$reset" \
    LESS_TERMCAP_mr="$(tput rev)" \
    LESS_TERMCAP_mh="$(tput dim)" \
    LESS_TERMCAP_ZN="$(tput ssubm)" \
    LESS_TERMCAP_ZV="$(tput rsubm)" \
    LESS_TERMCAP_ZO="$(tput ssupm)" \
    LESS_TERMCAP_ZW="$(tput rsupm)" \
    man "$@"
}

add_alias() {
  local default_alias_file="${ZSH_FOLDER}/alias.zsh"
  local name=${1:-}
  local cmd=${2:-}
  local alias_file=${3:-${default_alias_file}}
  if [[ ! -f ${alias_file} ]]; then
    echo_stderr "Alias file does not exist."
    return 1
  fi
  if [[ -n ${name} && -n ${cmd} ]]; then
    local a="alias ${name}='${cmd}'"
    echo_stderr "${a} >> ${alias_file}"
    echo "${a}" >>"${alias_file}"
    return 0
  else
    echo_stderr "usage: add_alias <name> <command>"
    return 1
  fi
}

open_pattern() {
  local pattern=${1:-}
  local opener=${2:-open}
  if [[ -z ${pattern} ]]; then
    echo_stderr "usage: open_pattern <pattern> [prog]"
    return 1
  fi
  setopt NULL_GLOB
  local cts=(*)
  local found=0
  for e in "${cts[@]}"; do
    if [[ ${e} == *${pattern} ]]; then
      found=1
      echo "${e}"
      $opener "${e}"
      break
    fi
  done
  unsetopt NULL_GLOB
  if [[ ${found} == 0 ]]; then
    echo "Nothing to open. (Looking for ${pattern})"
    return 1
  fi
}

workspace() {
  open_pattern ".xcworkspace/"
}

sp() {
  open_pattern ".sublime-project" subl
}

ppath() {
  echo "$PATH" | tr ':' '\n'
}

rbinstall() {
  RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)" rbenv install "$@"
}

yhome() {
  local name
  name=$(yarn --silent info "$1" --json | jq '.data.homepage' | tr -d '"')
  echo "${name}"
  open "${name}"
}

hupfile() {
  local filename=${1:-}
  if [[ -z $filename ]]; then
    echo_stderr "usage: hupfile <filename>"
    return 1
  fi
  if [[ ! -f $filename ]]; then
    echo_stderr "No file named $filename"
    return 1
  fi
  kill -s HUP "$(cat "$filename")"
  return $?
}

CUSTOM_COMP="${ZSH_FOLDER}/comp"

add_completion() {
  local completions_dir=${2:-${CUSTOM_COMP}}
  if [[ -z $completions_dir || ! -d $completions_dir ]]; then
    echo_stderr "Unable to find completions dir $completions_dir"
    return 1
  fi
  if has "$1"; then
    if [[ ! -f "${completions_dir}/_$1" ]]; then
      $1 completions zsh >"${completions_dir}/_$1"
    fi
  else
    echo_stderr "Unknown command $1"
  fi
}

fpath+=${CUSTOM_COMP}

_echo() {
  command printf %s\\n "$*" 2>/dev/null
}

__dofind() {
  if has gfind; then
    gfind "$@"
  else
    find "$@"
  fi
}

ls_pattern() {
  local pattern=${1:-}
  local startdir=${2:-}
  if [[ -z $pattern || -z $startdir ]]; then
    echo "ls_pattern <pattern> <startdir>" >&2
    return 1
  fi
  __dofind "$startdir" -type f -name "$pattern" -exec eza -la '{}' \+
}

ls_DS() {
  ls_pattern '*.DS_Store' "${1:-$PWD}"
}

del_DS() {
  __dofind "${1:-$PWD}" -type f -name '*.DS_Store' -ls -delete
}

lspyc() {
  ls_pattern '*.pyc' "${1:-$PWD}"
}

delpyc() {
  local dir=${1:-$PWD}
  __dofind "$dir" -name '*.pyc' -ls -delete
}

trashpyc() {
  local dir=${1:-$PWD}
  __dofind "$dir" -name '*.pyc' -ls -exec trash '{}' \+
}

ls_pkgs() {
  local dir="${1:-$PWD}/node_modules"
  __dofind "$dir" -type f -name package.json
}

merge_and_prune() {
  local pr=${1:-}
  if [[ -z $pr ]]; then
    echo "merge_and_prune <pr>" >&2
    return 1
  fi
  print_and_execute gh pr merge "$pr" --squash --delete-branch
  print_and_execute git fetch --prune
}
