#!/usr/bin/env bash

ZSH_FOLDER="${HOME}/Dropbox/config/zsh"

has() {
  type "$1" &> /dev/null
}

echo_stderr() {
  echo "$@" >&2
}

man() {
  # Shows pretty `man` page.
  local reset
  reset="$(tput sgr0)"
  env \
    LESS_TERMCAP_mb="$(
      tput bold
      tput setaf 1
    )" \
    LESS_TERMCAP_md="$(
      tput bold
      tput setaf 1
    )" \
    LESS_TERMCAP_me="$reset" \
    LESS_TERMCAP_so="$(
      tput bold
      tput setaf 3
      tput setab 4
    )" \
    LESS_TERMCAP_se="$reset" \
    LESS_TERMCAP_us="$(
      tput bold
      tput smul
      tput setaf 2
    )" \
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
    echo "${a}" >> "${alias_file}"
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

function pout() {
  poetry show --outdated
  yarn outdated
}

CUSTOM_COMP="${ZSH_FOLDER}/zshcomp"

add_completion() {
  local completions_dir=${2:-${CUSTOM_COMP}}
  if [[ -z $completions_dir || ! -d $completions_dir ]]; then
    echo_stderr "Unable to find completions dir $completions_dir"
    return 1
  fi
  if command -v "$1" 1> /dev/null 2>&1; then
    if [[ ! -f "${completions_dir}/_$1" ]]; then
      $1 completions zsh > "${completions_dir}/_$1"
    fi
  fi
}

fpath+=${CUSTOM_COMP}

_echo() {
  command printf %s\\n "$*" 2> /dev/null
}

_nvm_version_file() {
  local _path
  _path="$(nvm_find_up '.nvmrc')"
  if [ -e "${_path}/.nvmrc" ]; then
    _echo "${_path}/.nvmrc"
  else
    _path="$(nvm_find_up '.node-version')"
    if [ -e "${_path}/.node-version" ]; then
      _echo "${_path}/.node-version"
    fi
  fi
}

load-nvmrc() {
  local node_version
  node_version="$(nvm version)"
  local nvmrc_path
  nvmrc_path="$(_nvm_version_file)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
  fi
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

findpyc() {
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
  gh pr merge "$pr" --squash --delete-branch
  git fetch --prune
}
