require('nvim-treesitter.configs').setup({
  ensure_installed = { "go", "comment" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})
