# shellcheck disable=SC2148
antigen use oh-my-zsh

antigen bundle cargo
antigen bundle django
antigen bundle gitfast
antigen bundle httpie
antigen bundle npm
antigen bundle yarn
antigen bundle ripgrep
antigen bundle docker
antigen bundle docker-compose

antigen bundle lukechilds/zsh-nvm
antigen bundle zsh-users/zsh-completions
# antigen bundle zsh-users/zsh-autosuggestions
# antigen bundle djui/alias-tips
antigen bundle zdharma/fast-syntax-highlighting
# antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply
