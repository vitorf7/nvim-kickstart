return {
  'mikavilpas/yazi.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  enabled = function()
    if vim.fn.executable 'yazi' == 1 then
      return true
    end
    return false
  end,
  lazy = true,
  keys = {
    {
      '<leader>uy',
      function()
        require('yazi').toggle()
      end,
      desc = '[U]I: Toggle [Y]azi',
    },
    {
      '<leader>E',
      function()
        require('yazi').toggle()
      end,
      desc = 'UI: Toggle Yazi [E]xplorer',
    },
  },
}
