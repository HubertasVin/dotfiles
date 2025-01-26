require "nvchad.options"

-- add yours here!
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "c",
    "cpp",
    "cs",
    "css",
    "go",
    "fish",
    "html",
    "java",
    "javascript",
    "javascriptreact",
    "json",
    "python",
    "rust",
    "sh",
    "sql",
    "xml",
    "typescript",
    "typescriptreact",
    "yaml",
    "zsh",
  },
  callback = function()
    if vim.bo.filetype == "c" then
      -- For C files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "cpp" then
      -- For C files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "cs" then
      -- For CS files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "css" then
      -- For CSS files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "go" then
      -- For GO files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "html" then
      -- For HTML files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "java" then
      -- For Java files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "javascript" or vim.bo.filetype == "javascriptreact" then
      -- For JavaScript files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "json" then
      -- For Json files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "lua" then
      -- For JavaScript files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "python" then
      -- For Python files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "rust" then
      -- For Rust files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "sql" then
      -- For SQL files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
      -- For Typescript files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "yaml" then
      -- For YAML files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif vim.bo.filetype == "xml" then
      -- For XML files
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
    elseif
      vim.bo.filetype == "sh"
      or vim.bo.filetype == "bash"
      or vim.bo.filetype == "zsh"
      or vim.bo.filetype == "fish"
    then
      -- For Shell files
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
    end
  end,
})
