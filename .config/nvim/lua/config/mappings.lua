local Utils = require("utils")

local nmap = Utils.nmap
local imap = Utils.imap

local default_options = { noremap = true, silent = true }

Utils.generic_map("", "Q", "gq") -- Don't use Ex mode, use Q for formatting

--[[ CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
so that you can undo CTRL-U after inserting a line break. --]]
imap("<C-U>", "<C-G>u<C-U>")

vim.keymap.set("n", "B", "^", Utils.map_options({ desc = "Go to beginning of line." }))
vim.keymap.set("n", "E", "$", Utils.map_options({ desc = "Go to end of line." }))

-- Disable default beginning/end keys
vim.keymap.set("n", "^", "<nop>", Utils.default_map_options)
vim.keymap.set("n", "$", "<nop>", Utils.default_map_options)

-- Move down by visual line
nmap("j", "gj")
-- Move up by visual line
nmap("k", "gk")
-- Highlight last inserted text
nmap("gV", "`[v`]")

-- First Tab
vim.keymap.set("n", "tf", "<cmd>:tabfirst<cr>", { desc = "Go to first tab" })
-- Last Tab
vim.keymap.set("n", "tl", "<cmd>:tablast<cr>", { desc = "Go to last tab" })

-- Unhighlight everything
vim.keymap.set("n", "<leader>no", "<cmd>:noh<cr>")
vim.keymap.set("n", "<leader><space>", "<cmd>:noh<cr>")

-- persistence
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore session for the current directory" })
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end, { desc = "Select a session to load" })
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Restore the last session" })
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Stop persistence." })

-- Neogen
vim.keymap.set("n", "<leader>nf", function()
  require("neogen").generate()
end, { desc = "Generate annotations", noremap = true, silent = true })
