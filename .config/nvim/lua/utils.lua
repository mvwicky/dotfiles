local api = vim.api

local M = {}

function M.create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      api.nvim_command(command)
    end
    api.nvim_command("augroup END")
  end
end

function M.generic_map(mode, shortcut, command, options)
  if options == nil then
    options = {}
  end
  if options.noremap == nil then
    options.noremap = true
  end
  if options.silent == nil then
    options.silent = true
  end
  api.nvim_set_keymap(mode, shortcut, command, options)
end

function M.nmap(shortcut, command, options)
  M.generic_map("n", shortcut, command, options)
end

function M.imap(shortcut, command, options)
  M.generic_map("i", shortcut, command, options)
end

return M
