#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

out() {
  echo "$@" >&2
}

__has() {
  type "$1" &>/dev/null
}

arr_to_str() {
  local IFS=${1:- }
  shift 1
  echo "$*"
}

gen_completions() {
  local cmd=${1:-}
  if [[ -z $cmd ]]; then
    return 1
  fi
  shift 1
  declare -a comp_cmd
  comp_cmd+=("$@")
  local comp_file="${comp_dir}/_${cmd}"
  out "Generating $cmd completions ('$comp_file')"
  out "comp_cmd: \`$(arr_to_str ' ' "${comp_cmd[@]}")\`"
  set -x
  "${comp_cmd[@]}" >"$comp_file"
  set +x
}

comp_dir="zsh/comp"

if [[ ! -d $comp_dir ]]; then
  out "$comp_dir does not exist"
  exit 1
fi

if __has rustup; then
  gen_completions rustup rustup completions zsh
  gen_completions cargo rustup completions zsh cargo
fi

if __has poetry; then
  gen_completions poetry poetry completions zsh
fi

if __has ruff; then
  gen_completions ruff ruff generate-shell-completion zsh
fi

if __has rye; then
  gen_completions rye rye self completion -s zsh
fi

# if __has deno; then
#   gen_completions deno deno completions zsh
# fi
