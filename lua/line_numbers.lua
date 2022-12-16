-- Enable both regular and relative line numbers for hybrid line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Disable relative line numbers in cmd mode
local set_cmdline = vim.api.nvim_create_augroup("set_cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
    pattern = {"*"},
    callback = function()
        vim.opt.relativenumber = false
        vim.cmd('redraw')
    end,
    group = set_cmdline
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = {"*"},
    callback = function()
        vim.opt.relativenumber = true
        vim.cmd('redraw')
    end,
    group = set_cmdline
})

-- Disable relative line numbers in insert mode
local set_insert = vim.api.nvim_create_augroup("set_insert", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = {"*"},
    callback = function()
        vim.opt.relativenumber = false
        vim.cmd('redraw')
    end,
    group = set_insert
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = {"*"},
    callback = function()
        vim.opt.relativenumber = true
        vim.cmd('redraw')
    end,
    group = set_insert
})
