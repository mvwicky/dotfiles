local prettier_ft_names = {
  "css",
  "html",
  "htmldjango",
  "json",
  "jsonc",
  "markdown",
  "scss",
  "yaml",
}
local prettier_eslint_fts =
  { "javascript", "javascriptreact", "typescript", "typescriptreact" }
local prettier_fts = {}
for i, v in ipairs(prettier_ft_names) do
  prettier_fts[v] = { "prettierd" }
end
for i, v in ipairs(prettier_eslint_fts) do
  prettier_fts[v] = { "eslint_d", "prettierd" }
end

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = vim.tbl_extend("force", prettier_fts, {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        rust = { "rustfmt" },
      }),
      default_format_options = { lsp_format = "fallback" },
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
  },
  { "raimondi/delimitmate", event = { "BufReadPre", "BufNewFile" } },
  {
    "tpope/vim-commentary",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    enabled = function()
      return not vim.version.ge({ 0, 10, 0 }, vim.version())
    end,
  },
  { "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" } },
  { "folke/persistence.nvim", opts = { need = 2 }, event = "BufReadPre" },
  { "danymat/neogen", config = true, event = { "BufReadPre", "BufNewFile" } },
}
