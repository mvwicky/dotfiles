" Vim/Neovim Configuration
" Michael Van Wickle
" Misc {{{
syntax enable                   " Switch syntax highlighting on
set termguicolors
set undofile                    " keep an undo file (undo changes after closing)
set hidden
set updatetime=300              " write swap file after this many milliseconds
set backspace=indent,eol,start
set autoread                    " Reload if current file is changed
set modelines=2                 " First two lines can be modelines
set shortmess+=c
set whichwrap=<,>,[]
" }}}
" Spaces and Tabs {{{
set tabstop=4          " Tabs have a (visual) width of 4 spaces
set expandtab          " Tabs converted to spaces
set softtabstop=4      " Expand tabs into this many spaces
set shiftwidth=4       " Number of spaces for autoindent (affects <<, >>, and ==)
set smarttab
set autoindent         " Autoindent
filetype plugin on     " Enable file type detection
" Use the default filetype settings, so that mail gets 'textwidth' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype indent on
" }}}
" UI {{{
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands
set number             " Show line number
set numberwidth=4      " The width of the line numbers column
set signcolumn=yes     " Extra padding in line number column
set cursorline         " Highlight current line
set wildmenu           " Command-line completion enhanced
set showmatch          " Show matching brackets
set title              " Set window title, based on current file
set noerrorbells       " Don't ring bell
set cc=120             " Colored column at col 120
set laststatus=2       " Always show last status
set scrolloff=10       " Minimum lines on either side of cursor
set display+=lastline  " Try to display the last line of a paragraph
set encoding=utf-8     " Use utf-8
set linebreak          " Wrap long lines
set fillchars+=vert:\|
set lazyredraw

if exists("$TMUX")
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" }}}
" Search {{{
set ignorecase
set smartcase
set incsearch            " Incrementally highlight search
set hlsearch             " Switch on highlighting the last used search pattern.
" }}}
" Backups {{{
set backup                             " keep a backup file (restore to previous version)
set backupdir=$XDG_DATA_HOME/nvim/backup
set backupskip=/tmp/*,/private/tmp/*
set directory=$XDG_DATA_HOME/nvim/swap
set writebackup
" }}}
" Folding {{{
set foldnestmax=10
set foldenable
set foldlevelstart=10
" }}}
" AutoGroups {{{
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

    autocmd BufReadPost *.code-workspace set syntax=jsonc
    autocmd BufReadPost *.sublime-project set syntax=jsonc
    autocmd BufReadPost *.djt set syntax=htmldjango
    autocmd BufReadPost *.envrc set syntax=sh
    autocmd BufReadPost .ignore set syntax=conf
    autocmd BufReadPost *.gitconfig set syntax=gitconfig
    autocmd BufReadPost *.flake8 set syntax=dosini
augroup END

augroup configgroup
    autocmd!
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync

    " Strip trailing whitespace on write
    autocmd BufWritePre *.vim :call <SID>StripTrailingWhitespaces()
    autocmd FileType python setlocal colorcolumn=88

" File Specific Settings {{{
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd FileType gitconfig setlocal noexpandtab
    autocmd FileType typescript,javascript,json,jsonc,yaml,markdown setlocal colorcolumn=80
    autocmd FileType typescript,javascript,json,jsonc,yaml,markdown setlocal shiftwidth=2
    autocmd FileType typescript,javascript,json,jsonc,yaml,markdown setlocal softtabstop=2
    autocmd FileType zsh,sh,bash setlocal softtabstop=2
    autocmd FileType zsh,sh,bash setlocal shiftwidth=2
    " autocmd FileType typescript,javascript,json,jsonc setlocal tabstop=2
"}}}
    autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
" }}}
" Keyboard Mapping {{{
" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Go to beginning of the line
nnoremap B ^
" Go to the end of the line
nnoremap E $

" Disable default beginning/end keys
nnoremap ^ <nop>
nnoremap $ <nop>

" Move down by visual line
nnoremap j gj
" Move up by visual line
nnoremap k gk
" Highlight last inserted text
nnoremap gV `[v`]
" }}}
" Leader Shortcuts {{{
let mapleader=","

" Edit this file
nnoremap <leader>ev :tabe $MYVIMRC<CR>
" Reload this file
nnoremap <leader>sv :source $MYVIMRC<CR>
" Edit ZSHRC
nnoremap <leader>ez :tabe ~/.zshrc<CR>
" Unhighlight everything
nnoremap <leader>no :noh<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader>f :NERDTreeToggle<CR>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader>d :IndentBlanklineToggle<CR>

inoremap <silent><expr> <C-space> coc#refresh()
nnoremap <leader>rn <Plug>(coc-rename)
" }}}
" Plugin Definition {{{
call plug#begin()
    Plug 'morhetz/gruvbox'
    Plug 'haishanh/night-owl.vim'
    Plug 'sjl/badwolf'

    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'raimondi/delimitmate'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'airblade/vim-gitgutter'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'rust-lang/rust.vim'
    Plug 'ekalinin/dockerfile.vim'
    Plug 'glench/vim-jinja2-syntax'
    Plug 'cespare/vim-toml'
    Plug 'dag/vim-fish'
    Plug 'vim-scripts/django.vim'
    Plug 'pangloss/vim-javascript'
    Plug 'kevinoid/vim-jsonc'
    Plug 'zah/nim.vim'

    Plug 'scrooloose/nerdtree'
    Plug 'prettier/vim-prettier', {'do': 'yarn install', 'for': ['json', 'jsonc', 'markdown', 'html', 'htmldjango']}
    Plug 'romainl/apprentice'
    Plug 'luochen1990/rainbow'

    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-airline/vim-airline'

    Plug 'z0mbix/vim-shfmt', {'for': 'sh'}
    " Plug 'yggdroot/indentline'
    Plug 'lukas-reineke/indent-blankline.nvim'

    Plug 'sjl/gundo.vim'
    " Plug 'plasticboy/vim-markdown'
    " Plug 'vim-latex/vim-latex'
    " Plug 'pprovost/vim-ps1'
call plug#end()
" }}}
" Plugin Configuration {{{
let c_comment_strings = 1
let python_highlight_all = 1

let home = getenv("HOME")
let g:python_host_prog = home . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = home . '/.pyenv/versions/neovim/bin/python'

let g:node_host_prog = home . "/bin/yarn/bin/neovim-node-host"

let g:NERDTreeShowHidden = 1
let g:NERDTreeDirArrowExpandable = "→"
let g:NERDTreeDirArrowCollapsible= "↓"
let g:NERDTreeCustomOpenArgs = {"file": {"reuse": "all", "where": "t", "stay": 0}}

let g:prettier#autoformat = 0

let g:rainbow_active = 1

let g:indentLine_enabled = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indent_blankline_disable_warning_message = v:false

let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_start_level = 2

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_math = 1

let g:shfmt_extra_args = '-i 2'

let g:rustfmt_autosave = 1

let g:gruvbox_improved_strings = 0
let g:gruvbox_invert_indent_guides = 0
let g:gruvbox_number_column = 'bg1'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

let g:badwolf_darkgutter = 0
let g:badwolf_tabline = 3

let g:javascript_plugin_jsdoc = 1

let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-rust-analyzer', 'coc-yaml', 'coc-pyright']

let g:airline_theme='badwolf'
let g:airline#extensions#coc#enabled = 1
" }}}
" Colors {{{
colorscheme gruvbox
set background=dark
" }}}
" Commands {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif
" }}}
" Functions {{{
function! <SID>StripTrailingWhitespaces()
    " Save last search/cursor pos
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunc
" }}}

" vim:foldmethod=marker:foldlevel=0
