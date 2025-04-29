return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("config.alpha")
  end,
}
