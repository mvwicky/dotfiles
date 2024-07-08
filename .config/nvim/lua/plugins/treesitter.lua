return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "html",
          "javascript",
          "json",
          "jsonc",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "scss",
          "tsx",
          "typescript",
          "vimdoc",
        },
        highlight = { enable = true },
        indent = { enable = true },
        sync_install = false,
      })
    end,
    build = ":TSUpdate",
  },
}
