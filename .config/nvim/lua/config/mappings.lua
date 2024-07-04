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

-- First Tab
vim.keymap.set("n", "tf", "<cmd>:tabfirst<cr>", { desc = "Go to first tab" })
-- Last Tab
vim.keymap.set("n", "tl", "<cmd>:tablast<cr>", { desc = "Go to last tab" })

-- Unhighlight everything
vim.keymap.set("n", "<leader>no", "<cmd>:noh<cr>")
vim.keymap.set("n", "<leader><space>", "<cmd>:noh<cr>")

-- persistence
vim.keymap.set(
  "n",
  "<leader>qs",
  [[<cmd>lua require("persistence").load()<cr>]],
  { desc = "Restore session for the current directory" }
)
vim.keymap.set(
  "n",
  "<leader>ql",
  [[<cmd>lua require("persistence").load({ last = true })<cr>]],
  { desc = "Restore the last session" }
)
vim.keymap.set(
  "n",
  "<leader>qd",
  [[<cmd>lua require("persistence").stop()<cr>]],
  { desc = "Stop persistence." }
)

-- Neogen
vim.keymap.set(
  "n",
  "<leader>nf",
  [[<cmd>lua require("neogen").generate()<cr>]],
  { desc = "Generate annotations", noremap = true, silent = true }
)
