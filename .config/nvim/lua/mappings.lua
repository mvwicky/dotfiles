local function generic_map(mode, shortcut, command, options)
  if options == nil then
    options = {}
  end
  if options.noremap == nil then
    options.noremap = true
  end
  if options.silent == nil then
    options.silent = true
  end
  vim.api.nvim_set_keymap(mode, shortcut, command, options)
end

-- local function map(shortcut, command)
--     generic_map("", shortcut, command)
-- end

local function nmap(shortcut, command, options)
  generic_map("n", shortcut, command, options)
end

local function imap(shortcut, command, options)
  generic_map("i", shortcut, command, options)
end

generic_map("", "Q", "gq") -- Don't use Ex mode, use Q for formatting

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

-- Edit this file
nmap("<leader>ev", ":tabe $MYVIMRC<CR>")
-- Reload this file
nmap("<leader>sv", ":source $MYVIMRC<CR>")
-- Edit ZSHRC
nmap("<leader>ez", ":tabe ~/.zshrc<CR>")
-- Unhighlight everything
nmap("<leader>no", ":noh<CR>")
nmap("<leader><space>", ":noh<CR>")
-- nmap("<leader>f", ":NERDTreeToggle<CR>")
-- nmap("<leader>u", ":GundoToggle<CR>")
-- nmap("<leader>d", ":IndentBlanklineToggle<CR>")

nmap("<leader>ff", "<cmd>Telescope find_files<cr>")

-- imap("<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]], { expr = true })
-- imap("<C-space>", "coc#refresh()", { expr = true })
-- nmap("<leader>rn", "<Plug>(coc-rename)")
