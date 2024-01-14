--[[
local cmp = require("cmp")
local sources = {
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "vsnip" },
  { name = "path" },
}
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
  },
  sources = cmp.config.sources(sources),
})

local initialCap = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").update_capabilities(initialCap)

local lspconfig = require("lspconfig")
local servers = { "pyright", "tsserver", "jsonls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({ capabilities = capabilities })
end
--]]

local lsp = require("lsp-zero")
-- local lsp = require("lsp-zero").preset({
--   name = "minimal",
--   set_lsp_keymaps = { preserve_mappings = true, omit = {} },
--   manage_nvim_cmp = {
--     set_sources = "recommended",
--     set_basic_mappings = true,
--     set_extra_mappings = false,
--     use_luasnip = true,
--     set_format = true,
--     documentation_window = true,
--   },
-- })
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "tsserver", "pyright", "jsonls" },
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      local lua_opts = lsp.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)
    end,
  },
})
local cmp = require("cmp")
local cmp_format = lsp.cmp_format()
local cmp_action = lsp.cmp_action()

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  formatting = cmp_format,
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "luasnip" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  }),
})
-- lsp.ensure_installed({ "tsserver" })
-- require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
-- lsp.setup()
