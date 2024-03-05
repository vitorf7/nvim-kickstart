return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    -- "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    vim.cmd [[hi WinBar guibg=NONE]]
  end,
}
