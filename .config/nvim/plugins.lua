local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  local pack_url = "https://github.com/wbthomason/packer.nvim"
  Packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    pack_url,
    install_path,
  })
end

local function startup_function(use)
  use("wbthomason/packer.nvim")

  use("morhetz/gruvbox")

  use({ "HerringtonDarkholme/yats.vim", ft = { "typescript" } })

  use("rust-lang/rust.vim")
  use("ekalinin/dockerfile.vim")
  use("glench/vim-jinja2-syntax")
  use("cespare/vim-toml")
  use("dag/vim-fish")
  use("vim-scripts/django.vim")
  use("pangloss/vim-javascript")
  use("kevinoid/vim-jsonc")
  use("vim-python/python-syntax")

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        show_end_of_line = true,
        char_list = { "|", "¦", "┆", "┊" },
      })
    end,
  })

  use({
    "prettier/vim-prettier",
    run = "yarn install --frozen-lockfile --production",
    ft = { "json", "jsonc", "markdown", "html", "htmldjango" },
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({ current_line_blame = false })
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  })
  use("raimondi/delimitmate")
  use("tpope/vim-commentary")
  use("tpope/vim-surround")
  use("kyazdani42/nvim-web-devicons")

  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({
        options = { theme = "gruvbox" },
        sections = {
          lualine_x = { "encoding", "fileformat", "filetype", "g:coc_status" },
        },
      })
    end,
  })

  -- use "romainl/apprentice"
  use("luochen1990/rainbow")

  use({ "neovim/nvim-lspconfig", "williamboman/nvim-lsp-installer" })
  --[[
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp" -- LSP Completion Source
  use "hrsh7th/cmp-vsnip" -- Snippet (vsnip) Completion Source
  use "hrsh7th/cmp-buffer" -- Buffer Completion Source
  use "hrsh7th/cmp-path" -- Filesystem Completion Source

  use "hrsh7th/vim-vsnip" -- Snippet Engine

  use {
    "glepnir/lspsaga.nvim",
    config = function()
      require("lspsaga").init_lsp_saga({
        error_sign = "!",
        warn_sign = "^",
        hint_sign = "?",
        infor_sign = "~",
        border_style = "round"
      })
    end
  }
--]]
  use("glepnir/lspsaga.nvim")
  use({ "neoclide/coc.nvim", branch = "release" })

  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

  if Packer_bootstrap then
    require("packer").sync()
  end
end

return require("packer").startup(startup_function)
