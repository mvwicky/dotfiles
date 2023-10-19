local Utils = require("utils")

local nmap = Utils.nmap
local imap = Utils.imap

Utils.generic_map("", "Q", "gq") -- Don't use Ex mode, use Q for formatting

--[[ CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
so that you can undo CTRL-U after inserting a line break. --]]
imap("<C-U>", "<C-G>u<C-U>")

-- Go to beginning of the line
nmap("B", "^")
-- Go to the end of the line
nmap("E", "$")

-- Disable default beginning/end keys
nmap("^", "<nop>")
nmap("$", "<nop>")

-- Move down by visual line
nmap("j", "gj")
-- Move up by visual line
nmap("k", "gk")
-- Highlight last inserted text
nmap("gV", "`[v`]")

-- Edit ZSHRC
nmap("<leader>ez", ":tabe ~/.zshrc<CR>")
-- Unhighlight everything
nmap("<leader>no", ":noh<CR>")
nmap("<leader><space>", ":noh<CR>")
-- nmap("<leader>f", ":NERDTreeToggle<CR>")
-- nmap("<leader>u", ":GundoToggle<CR>")
-- nmap("<leader>d", ":IndentBlanklineToggle<CR>")

nmap("<leader>ff", "<cmd>Telescope find_files<cr>")
nmap("<leader>tt", ":TroubleToggle<CR>")

-- imap("<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]], { expr = true })
-- imap("<C-space>", "coc#refresh()", { expr = true })
-- nmap("<leader>rn", "<Plug>(coc-rename)")
