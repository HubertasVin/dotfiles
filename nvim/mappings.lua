require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Function to toggle a horizontal terminal
local function toggle_horizontal_terminal()
  -- Check if there is an existing terminal buffer
  local term_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      term_buf = buf
      break
    end
  end

  if term_buf and vim.api.nvim_buf_is_loaded(term_buf) then
    -- If terminal is open, close it
    vim.api.nvim_buf_delete(term_buf, { force = true })
  else
    -- If no terminal, open a new horizontal split with terminal
    vim.cmd("split | terminal")
    vim.cmd("resize 15")  -- Adjust the height of the terminal split
  end
end


-- Open CMD line without holding shift
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Custom mapping: Map <leader>fj to HopWord in normal mode
map("n", "<leader>fj", "<cmd>HopWord<CR>", { desc = "Hop Hop to word" })

-- Map a key to toggle the horizontal terminal, e.g., <leader>th
map("n", "<M-h>", toggle_horizontal_terminal, { desc = "Toggle Toggleable horizontal term" })
