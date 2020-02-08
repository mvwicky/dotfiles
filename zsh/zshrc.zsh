setopt hist_ignore_dups
setopt hist_expire_dups_first

SAVEHIST=99999
HYPHEN_INSENSITIVE="false"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

BREW_PREFIX="$(brew --prefix)"

if type brew &>/dev/null; then
    FPATH="${BREW_PREFIX}/share/zsh/site-functions:$FPATH"
    FPATH="${BREW_PREFIX}/share/zsh-completions:$FPATH"
fi

source $HOME/antigen.zsh
antigen init $HOME/.antigenrc

# Init pyenv
export PYENV_VIRTUALENV_VERBOSE_ACTIVATE=1
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
# Init rbenv
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

export SSH_KEY_PATH="~/.ssh/rsa_id"

export PATH="$HOME/bin/yarn/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"

DROPBOX_ZSH="${HOME}/Dropbox/zsh"
DROPBOX_FUNC="${DROPBOX_ZSH}/functions.zsh"
DROPBOX_ALIAS="${DROPBOX_ZSH}/alias.zsh"

# Load functions and aliases
test -f "${DROPBOX_FUNC}" && source "${DROPBOX_FUNC}"
test -f "${DROPBOX_ALIAS}" && source "${DROPBOX_ALIAS}"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(direnv hook zsh)"

if [[ -f "${HOME}/startup.py" ]]; then
    export PYTHONSTARTUP="${HOME}/startup.py"
fi

# Wasmer
export WASMER_DIR="/Users/michael/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer

eval "$(starship init zsh)"
