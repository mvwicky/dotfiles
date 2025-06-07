local Utils = require("utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      ts.install(Utils.ts_languages, { summary = true })
    end,
    build = function()
      require("nvim-treesitter").update(nil, { summary = true })
    end,
  },
}
