vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.g.lazyvim_check_order = false

vim.g.lazyvim_no_defaults = true

require("config.keymaps")
require("config.lazy")
