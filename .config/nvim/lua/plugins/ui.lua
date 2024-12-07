return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = { indent = { char = { "|", "¦", "┆", "┊" } } },
    keys = {
      { "<leader>d", "<cmd>:IndentBlanklineToggle<cr>" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Telescope find files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Telescope find live grep",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Telescope buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Telescope help tags",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          hijack_netrw_behavior = "open_default",
          filtered_items = { always_show = { ".gitignore" } },
        },
      })
    end,
    lazy = false,
    keys = {
      { "|", "<cmd>:Neotree reveal<cr>" },
      { "<leader>nb", "<cmd>:Neotree toggle show buffers right<cr>" },
      { "<leader>ng", "<cmd>:Neotree float git_status<cr>" },
    },
  },
  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
        sections = { lualine_x = { "encoding", "fileformat", "filetype" } },
      })
    end,
  },
  { "luochen1990/rainbow", event = { "BufReadPre", "BufNewFile" } },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cnd = "Trouble",
    keys = {
      { "<leader>tt", "<cmd>:Trouble diagnostics toggle<cr>" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "modern" },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
