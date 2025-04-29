return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      
      float_opts = {
        border = "curved",
        winblend = 0,
        width = math.floor(vim.o.columns * 0.85),
        height = math.floor(vim.o.lines * 0.85),
      },
    },
    config = true,
  }
}
