require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Custom mapping: Map <leader>fj to HopWord in normal mode
map("n", "<leader>fj", "<cmd>HopWord<CR>", { desc = "Hop to word" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
