return {
  { "sheerun/vim-polyglot", event = { "BufReadPre", "BufNewFile" } },
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "ekalinin/dockerfile.vim", ft = { "dockerfile" } },
  { "glench/vim-jinja2-syntax", enabled = false },
  { "cespare/vim-toml", ft = { "toml" } },
  { "vim-scripts/django.vim", event = { "BufEnter *.djt", "BufEnter *.html" } },
  { "pangloss/vim-javascript", ft = { "javascript", "javascriptreact" } },
  { "vim-python/python-syntax", ft = { "python" } },
  { "fladson/vim-kitty", event = { "BufReadPre", "BufNewFile" } },
  { "NoahTheDuke/vim-just", event = { "BufReadPre", "BufNewFile" } },
}
