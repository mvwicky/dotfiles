local api = vim.api

---@class MapOptions
---@field noremap? boolean
---@field silent? boolean
---@field expr? boolean
---@field buffer? boolean|number
---@field remap? boolean
---@field desc? string

local M = {}

M.default_map_options = { noremap = true, silent = true }

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

---@param options? MapOptions
---@return MapOptions
function M.map_options(options)
  if options == nil then
    options = {}
  end
  return vim.tbl_extend("force", M.default_map_options, options)
end

function M.generic_map(mode, shortcut, command, options)
  api.nvim_set_keymap(mode, shortcut, command, M.map_options(options))
end

function M.nmap(shortcut, command, options)
  M.generic_map("n", shortcut, command, options)
end

function M.imap(shortcut, command, options)
  M.generic_map("i", shortcut, command, options)
end

return M
