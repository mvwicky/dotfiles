return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "moon" })
      vim.cmd.colorscheme("tokyonight")
    end,
    enabled = true,
  },
  -- {
  --   "ramojus/mellifluous.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   enabled = false,
  --   config = function()
  --     require("mellifluous").setup({ colorset = "kanagawa_dragon" })
  --     vim.cmd.colorscheme("mellifluous")
  --   end,
  -- },
  -- {
  --   "oxfist/night-owl.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("night-owl").setup()
  --     vim.cmd.colorscheme("night-owl")
  --   end,
  -- },
}
