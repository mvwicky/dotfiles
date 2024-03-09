local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
local loop = vim.uv or vim.loop
if not loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

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

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
      require("tokyonight").setup({ style = "moon" })
    end,
  },
  "sheerun/vim-polyglot",
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "ekalinin/dockerfile.vim", ft = { "dockerfile" } },
  "glench/vim-jinja2-syntax",
  { "cespare/vim-toml", ft = { "toml" } },
  { "vim-scripts/django.vim", event = { "BufEnter *.djt", "BufEnter *.html" } },
  "pangloss/vim-javascript",
  "kevinoid/vim-jsonc",
  { "vim-python/python-syntax", ft = { "python" } },
  "fladson/vim-kitty",
  "NoahTheDuke/vim-just",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = { indent = { char = { "|", "¦", "┆", "┊" } } },
  },
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
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  },
  "raimondi/delimitmate",
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "nvim-tree/nvim-web-devicons",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
        sections = { lualine_x = { "encoding", "fileformat", "filetype" } },
      })
    end,
  },
  "luochen1990/rainbow",
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "markdown",
          "markdown_inline",
          "lua",
        },
        highlight = { enable = true },
        -- indent = { enable = true },
        sync_install = false,
      })
    end,
    build = ":TSUpdate",
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "williamboman/mason.nvim" }, -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "hrsh7th/cmp-buffer" },
      { "L3MON4D3/LuaSnip" }, -- Required
      { "saadparwaiz1/cmp_luasnip" },
      { "rafamadriz/friendly-snippets" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
})
