-- Enable both regular and relative line numbers for hybrid line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- Disable relative line numbers in cmd mode
local set_cmdline = vim.api.nvim_create_augroup("set_cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = { "*" },
  callback = function()
    if vim.wo.relativenumber == true then
      vim.wo.relativenumber = false
      vim.cmd('redraw')
    end
  end,
  group = set_cmdline
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = { "*" },
  callback = function()
    if vim.wo.relativenumber == false then
      vim.wo.relativenumber = true
      vim.cmd('redraw')
    end
  end,
  group = set_cmdline
})

-- Disable relative line numbers in insert mode
local set_insert = vim.api.nvim_create_augroup("set_insert", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = { "*" },
  callback = function()
    if vim.wo.relativenumber == true then
      vim.wo.relativenumber = false
      vim.cmd('redraw')
    end
  end,
  group = set_insert
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = { "*" },
  callback = function()
    if vim.wo.relativenumber == false then
      vim.wo.relativenumber = true
      vim.cmd('redraw')
    end
  end,
  group = set_insert
})
