#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)

RESET=$(tput sgr0)

ZSH_FOLDER="${HOME}/Dropbox/zsh"

brundle() {
  local cmd=${1:-}
  if [[ -z $cmd ]]; then
    pushd "${HOME}/Dropbox" || return
    brew bundle
    popd || return
  fi
}

burp() {
  echo "brew update"
  brew update
  local outdated
  outdated=$(brew outdated)
  if [[ -n ${outdated} ]]; then
    echo "brew upgrade"
    brew upgrade
  else
    echo "nothing outdated"
  fi
}

echo_stderr() {
  echo "$@" >&2
}

colorize() {
  local code=${1:-}
  local s=${2:-}
  if [[ -z ${code} ]]; then
    echo_stderr "usage: colorize <code> <string>"
    return 1
  else
    local outstring="\e[${code}m${s}\e[0m"
    echo "${outstring}"
  fi
}

echo_red() {
  echo -e "${RED}${1:-}${RESET}" >&2
}

echo_green() {
  echo -e "${GREEN}${1:-}${RESET}" >&2
}

echo_yellow() {
  echo -e "${YELLOW}${1:-}${RESET}" >&2
}

echo_blue() {
  echo -e "${BLUE}${1:-}${RESET}" >&2
}

man() {
  # Shows pretty `man` page.
  env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[1;32m")" \
    man "$@"
}

add_alias() {
  local alias_file="${ZSH_FOLDER}/alias.zsh"
  if [[ ! -f ${alias_file} ]]; then
    echo_stderr "Alias file does not exist."
    return 1
  fi
  local name=${1:-}
  local cmd=${2:-}
  if [[ -n ${name} && -n ${cmd} ]]; then
    local a="alias ${name}='${cmd}'"
    echo_green "${a} >> ${alias_file}"
    echo "${a}" >> "${alias_file}"
    return 0
  else
    echo_red "usage: add_alias <name> <command>"
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

sumpyc() {
  python3 << EOF
import os

n, total = 0, 0
cwd = os.getcwd()
for root, _, files in os.walk(cwd):
    for file in files:
        if file.endswith('.pyc'):
            n += 1
            total += os.path.getsize(os.path.join(root, file))
print(n, total)
EOF
}

print_path() {
  python3 << EOF
import os
print("\n".join(os.environ["PATH"].split(os.pathsep)))
EOF
}

findpyc() {
  local dir=${1:-$PWD}
  find "$dir" -name '*.pyc'
}

delpyc() {
  find . -name '*.pyc' -delete
}

pyinstall() {
  local brewssl
  brewssl=$(brew --prefix openssl)
  local xcsdk
  xcsdk=$(xcrun --show-sdk-path)
  CFLAGS="-I$brewssl/include -I$xcsdk/usr/include -O2" LDFLAGS="-L$brewssl/lib" pyenv install "$@"
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

pipxr() {
  local bindir=${PIPX_BIN_DIR:-$HOME/.local/bin}
  local exe=${1:-}
  if [[ -z $exe ]]; then
    echo_stderr "usage: pipxr <exe> [OPTIONS...]"
    return 1
  fi
  local exepath="${bindir}/${exe}"
  if [[ ! -x $exepath ]]; then
    echo_stderr "$exe does not exist."
    return 1
  fi
  shift 1
  local cmd="$exepath $*"
  echo "$cmd"
  eval "${cmd}"
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

CUSTOM_COMP="${ZSH_FOLDER}/.zshcomp"

add_completion() {
  if command -v "$1" 1> /dev/null 2>&1; then
    if [[ ! -f "${CUSTOM_COMP}/_$1" ]]; then
      $1 completions zsh > "${CUSTOM_COMP}/_$1"
    fi
  fi
}

# add_completion poetry
# add_completion diesel
# add_completion rustup

fpath+=${CUSTOM_COMP}
