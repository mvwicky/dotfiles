return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmd = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      {
        {
          "L3MON4D3/LuaSnip",
          build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,
          dependencies = { "rafamadriz/friendly-snippets" },
        },
      },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      local lsp_z = require("lsp-zero")
      lsp_z.extend_cmp()
      local cmp = require("cmp")
      local cmp_action = lsp_z.cmp_action()
      local cmp_format = lsp_z.cmp_format()
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
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      local lsp_z = require("lsp-zero")
      lsp_z.extend_lspconfig()
      lsp_z.on_attach(function(client, bufnr)
        lsp_z.default_keymaps({ buffer = bufnr })
      end)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "eslint",
          "html",
          "jsonls",
          "basedpyright",
          "rust_analyzer",
          "ts_ls",
          "ruff",
        },
        handlers = {
          lsp_z.default_setup,
          lua_ls = function()
            local lua_opts = lsp_z.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })
      --Enable (broadcasting) snippet capability for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config("jsonls", { capabilities = capabilities })
    end,
  },
}
