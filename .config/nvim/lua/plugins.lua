local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
  -- {
  --   "luisiacc/gruvbox-baby",
  --   branch = "main",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd([[colorscheme gruvbox-baby]])
  --   end,
  -- },
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
  -- { "HerringtonDarkholme/yats.vim", ft = { "typescript" } },
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "ekalinin/dockerfile.vim", ft = { "dockerfile" } },
  "glench/vim-jinja2-syntax",
  { "cespare/vim-toml", ft = { "toml" } },
  "dag/vim-fish",
  "vim-scripts/django.vim",
  "pangloss/vim-javascript",
  "kevinoid/vim-jsonc",
  "vim-python/python-syntax",
  "fladson/vim-kitty",
  "NoahTheDuke/vim-just",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = { indent = { char = { "|", "¦", "┆", "┊" } } },
  },
  {
    "prettier/vim-prettier",
    build = "yarn install --frozen-lockfile --production",
    ft = {
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
      "typescriptreact",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  },
  "raimondi/delimitmate",
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "kyazdani42/nvim-web-devicons",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "kyazdani42/nvim-web-devicons" } },
    config = function()
      require("lualine").setup({
        -- options = { theme = "gruvbox-baby" },
        options = { theme = "tokyonight" },
        sections = {
          lualine_x = { "encoding", "fileformat", "filetype" },
        },
      })
    end,
  },
  "luochen1990/rainbow",
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "javascript", "typescript", "markdown", "markdown_inline" },
        highlight = { enable = true },
        indent = { enable = true },
        sync_install = false,
      })
    end,
    build = function()
      local ts_update = require("nvin-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "williamboman/mason.nvim" }, -- Optional
      {
        "williamboman/mason-lspconfig.nvim",
        -- config = function()
        --   require("mason-lspconfig").setup({ ensure_installed = { "tsserver" } })
        -- end,
      }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "hrsh7th/cmp-buffer" },
      { "L3MON4D3/LuaSnip" }, -- Required
    },
  },
})
