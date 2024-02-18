# shellcheck disable=SC2148
antigen use oh-my-zsh

antigen bundle rust
antigen bundle gitfast
antigen bundle httpie
antigen bundle yarn
antigen bundle ripgrep
# antigen bundle django
# antigen bundle npm
# antigen bundle docker
# antigen bundle docker-compose

antigen bundle zsh-users/zsh-completions
antigen bundle zdharma-continuum/fast-syntax-highlighting
# antigen bundle zsh-users/zsh-autosuggestions
# antigen bundle djui/alias-tips
# antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply
