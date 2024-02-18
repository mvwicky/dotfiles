local lsp = require("lsp-zero")
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
