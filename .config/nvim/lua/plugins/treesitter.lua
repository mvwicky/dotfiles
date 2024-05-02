return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "javascript",
          "typescript",
          "html",
          "markdown",
          "markdown_inline",
          "lua",
          "vimdoc",
        },
        highlight = { enable = true },
        -- indent = { enable = true },
        sync_install = false,
      })
    end,
    build = ":TSUpdate",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPre", "BufNewFile" },
  },
}
