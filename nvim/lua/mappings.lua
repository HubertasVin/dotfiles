require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LSP related mappings with descriptions
map("n", "K", vim.lsp.buf.hover, { desc = "Code Hover", table.unpack(opts) })
map("n", "gd", vim.lsp.buf.definition, { desc = "Code Go to Definition", table.unpack(opts) })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", table.unpack(opts) })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename", table.unpack(opts) })
map("n", "<leader>cu", require("telescope.builtin").lsp_references, { noremap = true, silent = true })

-- Format related mappings
map("n", "<leader>cf", function()
  require("conform").format()
end, { desc = "Format code", table.unpack(opts) })

map("v", "<leader>f", function()
  require("conform").format({ async = true }, function(err)
    if not err then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    end
  end)
end, { desc = "Format code selection" })

-- Open CMD line without holding shift
map("n", ";", ":")
map("v", ";", ":")

-- Custom mapping: Hop to word
map("n", "<leader>fj", "<cmd>HopWord<CR>", { desc = "Hop to word", table.unpack(opts) })

-- Paste without affecting clipboard
map("v", "P", "p", { desc = "Paste (clipboard unaware)", table.unpack(opts) })
map("v", "p", "P", { desc = "Alternate paste (clipboard preserved)", table.unpack(opts) })

-- Remap '>' and '<' to keep selection in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")
