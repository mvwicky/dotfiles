#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)

RESET=$(tput sgr0)

ZSH_FOLDER="${HOME}/Dropbox/zsh"

function brundle() {
    pushd "${HOME}/Dropbox" || return
    brew bundle
    popd || return
}

function echo_stderr() {
    echo "$@" >&2
}

function colorize() { local code=${1:-}
    local s=${2:-}
    if [[ -z "${code}" ]]; then
        echo_stderr "USAGE: colorize <code> <string>"
        return 1
    else
        local outstring="\e[${code}m${s}\e[0m"
        echo "${outstring}"
    fi
}

function echo_red() {
    echo -e "${RED}${1:-}${RESET}" >&2
}

function echo_green() {
    echo -e "${GREEN}${1:-}${RESET}" >&2
}

function echo_yellow() {
 echo -e "${YELLOW}${1:-}${RESET}" >&2
}

function echo_blue() {
 echo -e "${BLUE}${1:-}${RESET}" >&2
}

# man() {
  # Shows pretty `man` page.
#    env \
#     LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
#     LESS_TERMCAP_md="$(printf "\e[1;31m")" \
#     LESS_TERMCAP_me="$(printf "\e[0m")" \
#     LESS_TERMCAP_se="$(printf "\e[0m")" \
#     LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
#     LESS_TERMCAP_ue="$(printf "\e[0m")" \
#     LESS_TERMCAP_us="$(printf "\e[1;32m")" \
#       man "$@"
# }

add_alias() {
    local alias_file="${ZSH_FOLDER}/.zsh_alias"
    if [[ ! -f "${alias_file}" ]]; then
        echo_stderr "Alias file does not exist."
        return 1
    fi
    local name=${1:-}
    local cmd=${2:-}
    if [[ -n "${name}" && -n "${cmd}" ]]; then
        local a="alias ${name}='${cmd}'"
        echo_green "${a} >> ${alias_file}"
        echo "${a}" >> "${alias_file}"
        return 0
    else
        echo_red "USAGE: add_alias <name> <command>"
        return 1
    fi
}

workspace() {
    setopt NULL_GLOB
    cts=(*/)
    found=0
    for e in "${cts[@]}"
    do
        if [[ ${e} == *.xcworkspace/ ]]; then
            found=1
            echo "${e}"
            open "${e}"
            break
        fi
    done
    if [[ "${found}" == 0 ]]; then
        echo "No Workspace Found"
    fi

    unsetopt NULL_GLOB
}

sp() {
    setopt NULL_GLOB
    cts=(*)
    found=0
    for e in "${cts[@]}"
    do
        if [[ ${e} == *.sublime-project ]]; then
            found=1
            echo "${e}"
            subl --project "${e}"
            break
        fi
    done
    if [[ "${found}" == 0 ]]; then
        echo "No Sublime project found"
    fi
    unsetopt NULL_GLOB
}

CUSTOM_COMP="${ZSH_FOLDER}/.zshcomp"

function add_completion() {
    if command -v "$1" 1>/dev/null 2>&1; then
        if [[ ! -f "${CUSTOM_COMP}/_$1" ]]; then
            $1 completions zsh > "${CUSTOM_COMP}/_$1"
        fi
    fi
}

function sumpyc {
python3 << EOF
import os

n, total = 0, 0
for root, _, files in os.walk(os.getcwd()):
    for file in files:
        if file.endswith('.pyc'):
            n += 1
            total += os.path.getsize(os.path.join(root, file))
print(n, total)
EOF
}

function findpyc {
    local dir=${1:-$PWD}
    find "$dir" -name '*.pyc'
}

function delpyc {
    find . -name '*.pyc' -delete
}

function pyinstall() {
    CFLAGS="-I$(brew --prefix openssl)/include" LDFLAGS="-L$(brew --prefix openssl)/lib" pyenv install "$@"
}

function yhome() {
    local name
    name=$(yarn --silent info "$1" --json | jq '.data.homepage' | tr -d '"')
    echo "${name}"
    open "${name}"
}

# add_completion poetry
# add_completion diesel
# add_completion rustup

fpath+=${CUSTOM_COMP}

