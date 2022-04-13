" Switch syntax highlighting on
syntax enable
set termguicolors

set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands

" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

filetype plugin on

set backspace=indent,eol,start

set tabstop=4          " Tabs have a width of 4
set expandtab          " Tabs converted to spaces
set softtabstop=4
set shiftwidth=4       " Affects <<, >>, and ==
set smarttab

set modelines=1
set number             " Show line number
set numberwidth=4      " The width of the line numbers column

set cursorline         " Highlight current line
set wildmenu           " Command-line completion enhanced
set showmatch          " Show matching brackets

set autoindent         " Autoindent
set autoread           " Reload if current file is changed

set laststatus=2
set scrolloff=10

set display+=lastline  " Try to display the last line of a paragraph
set encoding=utf-8     " Use utf-8
set linebreak          " Wrap long lines

set title              " Set window title, based on current file
set noerrorbells       " Don't ring bell

set cc=120             " Colored column at col 120
set ignorecase
set smartcase
set incsearch
" Switch on highlighting the last used search pattern.
set hlsearch
" set fillchars+=vert:|

nnoremap B ^
nnoremap E $

nnoremap ^ <nop>
nnoremap $ <nop>

let c_comment_strings=1

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'textwidth' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype indent on

let python_highlight_all = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_math = 1
" let g:python_host_prog = '/Users/michael/.pyenv/versions/neovim2/bin/python'
let g:python_host_prog = getenv("HOME") . '/.pyenv/versions/neovim2/bin/python'
" let g:python3_host_prog = '/Users/michael/.pyenv/versions/neovim/bin/python'
let g:python3_host_prog = getenv("HOME") . '/.pyenv/versions/neovim/bin/python'
let g:node_host_prog = "$HOME/bin/yarn/bin/neovim-node-host"
let g:prettier#autoformat = 0

set backup             " keep a backup file (restore to previous version)
set backupdir=$XDG_DATA_HOME/nvim
set backupskip=/tmp/*,/private/tmp/*
set directory=$XDG_DATA_HOME/nvim
set writebackup

" autocmd BufEnter * silent! lcd %:p:h

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif


    autocmd BufReadPost *.djt set syntax=htmldjango
augroup END

augroup configgroup
    autocmd!
    " Strip trailing whitespace on write
    " autocmd BufWritePre * :%s/\s\+$//e
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync
    autocmd BufWritePre *.py execute ':Black'

    autocmd FileType python setlocal colorcolumn=80
    autocmd FileType typescript setlocal colorcolumn=80

    autocmd FileType typescript setlocal tabstop=2
    autocmd FileType typescript setlocal shiftwidth=2
    autocmd FileType typescript setlocal colorcolumn=80
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" Move down by visual line
nnoremap j gj
" Move up by visual line
nnoremap k gk
nnoremap gV `[v`]

" Leader Shortcuts
let mapleader=","

" Edit this file
nnoremap <leader>ev :tabe $MYVIMRC<CR>
" Reload this file
nnoremap <leader>sv :source $MYVIMRC<CR>
" nnoremap <leader>f :NERDTreeToggle<CR>
" nnoremap <leader>u :GundoToggle<CR>

call plug#begin()
    " Plug 'sjl/gundo.vim'
    " Plug 'sjl/badwolf'
    Plug 'morhetz/gruvbox'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
    Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'raimondi/delimitmate'
    Plug 'rust-lang/rust.vim'
    Plug 'ekalinin/dockerfile.vim'
    Plug 'glench/vim-jinja2-syntax'
    Plug 'cespare/vim-toml'
    " Plug 'plasticboy/vim-markdown'
    " Plug 'vim-latex/vim-latex'
    " Plug 'pprovost/vim-ps1'
    " Plug 'altercation/vim-colors-solarized'
    " Plug 'scrooloose/nerdtree'
    Plug 'ambv/black'
    Plug 'vim-scripts/django.vim'
    Plug 'prettier/vim-prettier', {'do': 'yarn install'}
    Plug 'romainl/apprentice'
    Plug 'luochen1990/rainbow'

    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-airline/vim-airline'

    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'z0mbix/vim-shfmt', {'for': 'sh'}
call plug#end()

let g:rainbow_active = 1
let g:deoplete#enable_at_startup = 1
let g:indent_guides_enable_on_vim_startup = 0

let g:shfmt_extra_args = '-i 2'
let g:rustfmt_autosave = 1

let g:gruvbox_number_column = 'bg1'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

colorscheme gruvbox
set background=dark

