vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<leader>oo", ":Oil<CR>", { desc = "Open Oil File Tree" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.keymap.set("n", "q", ":bd<CR>", { buffer = true, desc = "Close Oil" })
  end,
})
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Open fuzzy find" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Open live grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Search buffers" })
map("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })
map("n", "<leader>tt", ":ToggleTerm direction=horizontal<CR>", { desc = "Open terminal bottom" })
map("n", "<leader>w", ":tabnew<CR>", { desc = "Open a new empty buffer" })
map("n", "<leader>wn", ":bnext<CR>", { desc = "Go to the next buffer" })
map("n", "<leader>wp", ":bprev<CR>", { desc = "Go to the previous buffer" })
map("n", "<leader>wq", ":bdelete<CR>", { desc = "Close current buffer" })
