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
