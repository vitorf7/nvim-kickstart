return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {},
  config = function()
    vim.cmd [[hi WinBar guibg=NONE]]
  end,
}
