return {
  'DreamMaoMao/yazi.nvim',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },

  keys = {
    { '<leader>uy', '<cmd>Yazi<CR>', desc = '[U]I: Toggle [Y]azi' },
    { '<leader>E', '<cmd>Yazi<CR>', desc = 'UI: Toggle Yazi [E]xplorer' },
  },
}
