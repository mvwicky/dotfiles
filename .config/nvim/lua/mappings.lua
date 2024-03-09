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
-- nmap("<leader>ez", ":tabe ~/.zshrc<CR>")
-- Unhighlight everything
vim.keymap.set("n", "<leader>no", "<cmd>:noh<cr>")
vim.keymap.set("n", "<leader><space>", "<cmd>:noh<cr>")
vim.keymap.set("n", "|", "<cmd>:Neotree reveal<cr>")
vim.keymap.set("n", "<leader>nb", "<cmd>:Neotree toggle show buffers right<cr>")
vim.keymap.set("n", "<leader>ng", "<cmd>:Neotree float git_status<cr>")
-- nmap("<leader>f", ":NERDTreeToggle<CR>")
-- nmap("<leader>u", ":GundoToggle<CR>")
-- nmap("<leader>d", ":IndentBlanklineToggle<CR>")

-- Telescope Mappings
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
-- Trouble
vim.keymap.set("n", "<leader>tt", "<cmd>:TroubleToggle<cr>")
