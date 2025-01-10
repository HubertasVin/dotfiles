require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set


-- Open CMD line without holding shift
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Custom mapping: Map <leader>fj to HopWord in normal mode
map("n", "<leader>fj", "<cmd>HopWord<CR>", { desc = "Hop Hop to word" })

-- Paste without affecting clipboard
map("v", "P", "p", { desc = "Clipboard Paste by copying selected text" })
map("v", "p", "P", { desc = "Clipboard Paste without affecting clipboard" })

-- Remap '>' and '<' to keep selection in visual mode
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })
