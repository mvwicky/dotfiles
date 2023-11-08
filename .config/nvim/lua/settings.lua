local Utils = require("utils")

HOME = os.getenv("HOME")

vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.hidden = true
vim.opt.updatetime = 300
vim.opt.backspace = "indent,eol,start"
vim.opt.autoread = true -- Reload if current file is changed
vim.opt.modelines = 2 -- First to lines can be modelines
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.whichwrap = { ["<"] = true, [">"] = true, ["[]"] = true }

-- Spaces and Tabs {{{
vim.opt.tabstop = 4 -- Tabs have a (visual) width of 4 spaces
vim.opt.expandtab = true -- Tabs converted to spaces
vim.opt.softtabstop = 4 -- Expand tabs into this many spaces
vim.opt.shiftwidth = 4 -- Number of spaces for autoindent (affects <<, >>, and ==)
vim.opt.smarttab = true
vim.opt.autoindent = true
-- }}}

-- UI {{{
vim.opt.ruler = true -- show the cursor position all the time
vim.opt.showcmd = true -- display incomplete commands
vim.opt.number = true -- Show line number
vim.opt.numberwidth = 4 -- The width of the line numbers column
vim.opt.signcolumn = "yes" -- Extra padding in line number column
vim.opt.cursorline = true -- Highlight current line
vim.opt.wildmenu = true -- Command-line completion enhanced
vim.opt.showmatch = true -- Show matching brackets
vim.opt.title = true -- Set window title, based on current file
vim.opt.errorbells = false -- Don't ring bell
vim.opt.cc = "120" -- Colored column at col 120
vim.opt.laststatus = 2 -- Always show last status
vim.opt.scrolloff = 10 -- Minimum lines on either side of cursor
vim.opt.display = vim.opt.display + "lastline" -- Try to display the last line of a paragraph
vim.opt.encoding = "utf-8" -- Use utf-8
vim.opt.linebreak = true -- Wrap long lines
vim.opt.fillchars = { ["vert"] = "|" }
vim.opt.lazyredraw = true
-- }}}

vim.opt.completeopt = "menuone,noinsert,noselect"

--[[ TODO --]]
vim.cmd([[
if exists("$TMUX")
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
]])
--[[ --]]

-- Search {{{
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true -- Incrementally highlight search
vim.opt.hlsearch = true -- Switch on highlighting the last used search pattern.
-- }}}

-- Backups {{{
DATA_HOME = os.getenv("XDG_DATA_HOME")
if DATA_HOME ~= nil then
  vim.opt.backup = true -- keep a backup file (restore to previous version)
  vim.opt.backupdir = DATA_HOME .. "/nvim/backup"
  vim.opt.backupskip = "/tmp/*,/private/tmp/*"
  vim.opt.directory = DATA_HOME .. "/nvim/swap"
  vim.opt.writebackup = true
end
-- }}}

-- Folding {{{
vim.opt.foldnestmax = 10
vim.opt.foldenable = true
vim.opt.foldlevelstart = 10
-- }}}

-- AutoGroups {{{

vim.cmd([[
  augroup vimrcEx
    autocmd!

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
]])

local prettier_globs = vim.tbl_map(function(v)
  return "*." .. v
end, {
  "js",
  "jsx",
  "mjs",
  "ts",
  "tsx",
  "css",
  "scss",
  "json",
  "graphql",
  "vue",
  "yaml",
  "html",
})

Utils.create_augroups({
  filetypes = {
    "FileType text setlocal textwidth=78",
    "FileType Makefile setlocal noexpandtab",
    "FileType python setlocal colorcolumn=88",
    "FileType gitconfig setlocal noexpandtab",
    "FileType typescript,javascript,json,jsonc,yaml,markdown setlocal colorcolumn=80",
    "FileType typescript,javascript,json,jsonc,yaml,markdown setlocal shiftwidth=2",
    "FileType typescript,javascript,json,jsonc,yaml,markdown setlocal softtabstop=2",
    "FileType zsh,sh,bash setlocal softtabstop=2",
    "FileType zsh,sh,bash setlocal shiftwidth=2",
    [[FileType json syntax match Comment +\/\/.\+$+]],
  },
})

local bufwritepre = vim.api.nvim_create_augroup("bufwritepre", {})
vim.api.nvim_create_autocmd(
  { "BufWritePre" },
  { group = bufwritepre, pattern = prettier_globs, command = "PrettierAsync" }
)

-- local fts = vim.api.nvim_create_augroup("filetypes", {})
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = "Makefile",
--   group = fts,
--   callback = function(opts)
--     vim.print(opts)
--     vim.opt_local.expandtab = false
--     vim.opt_local.colorcolumn = 40
--   end,
-- })

-- }}}

vim.g.mapleader = ","

PYENV_ROOT = os.getenv("PYENV_ROOT") or HOME .. "/.pyenv"
vim.g.python_host_prog = PYENV_ROOT .. "/versions/neovim2/bin/python"
vim.g.python3_host_prog = PYENV_ROOT .. "/versions/neovim/bin/python"

vim.g.node_host_prog = HOME .. "/bin/yarn/bin/neovim-node-host"

-- Plugin Configuration {{{
vim.g.rainbow_active = 1

vim.g.python_highlight_all = 1

vim.g.gruvbox_improved_strings = 0
vim.g.gruvbox_invert_indent_guides = 0
vim.g.gruvbox_number_column = "bg1"
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_contrast_light = "hard"

vim.g.shfmt_extra_args = "-i 2"

vim.g.javascript_plugin_jsdoc = 1

vim.g.airline_theme = "gruvbox"

vim.g.coc_global_extensions = { "coc-tsserver", "coc-json", "coc-yaml", "coc-pyright" }
-- }}}

vim.g.gruvbox_baby_background_color = "hard"
vim.g.gruvbox_baby_telescope_theme = 1
vim.opt.background = "dark"
-- vim.cmd([[colorscheme gruvbox-baby]])
