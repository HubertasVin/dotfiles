require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LSP related mappings with descriptions
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover", table.unpack(opts) })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP Go to Definition", table.unpack(opts) })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action", table.unpack(opts) })

-- Open CMD line without holding shift
map("n", ";", ":")

-- Custom mapping: Hop to word
map("n", "<leader>fj", "<cmd>HopWord<CR>", { desc = "Hop to word", table.unpack(opts) })

-- Paste without affecting clipboard
map("v", "P", "p", { desc = "Paste (clipboard unaware)", table.unpack(opts) })
map("v", "p", "P", { desc = "Alternate paste (clipboard preserved)", table.unpack(opts) })

-- Remap '>' and '<' to keep selection in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")
