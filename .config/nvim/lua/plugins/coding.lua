local prettier_ft_names = {
  "css",
  "html",
  "htmldjango",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "markdown",
  "scss",
  "typescript",
  "yaml",
}
local prettier_fts = {}
for i, v in ipairs(prettier_ft_names) do
  prettier_fts[v] = { { "prettierd", "prettier" } }
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
          require("conform").format({ async = true, lsp_fallback = true })
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
      }),
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
  },
  { "raimondi/delimitmate", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-commentary", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" } },
}
