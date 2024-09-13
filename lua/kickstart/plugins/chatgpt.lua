return {
  'jackMort/ChatGPT.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function(_, opts)
    require('chatgpt').setup(opts)
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { '<leader>Ag', '<cmd>ChatGPT<cr>', desc = 'ChatGPT' },
    { '<leader>Aa', '<cmd>ChatGPTActAs<cr>', desc = 'ChatGPT Act As' },
    { '<leader>Ac', '<cmd>ChatGPTCompleteCode<cr>', desc = 'ChatGPT Complete Code' },
    { '<leader>Ae', '<cmd>ChatGPTEditWithInstructions<cr>', desc = 'ChatGPT Edit With Instructions' },
    { '<leader>Ar', '<cmd>ChatGPTRun<cr>', desc = 'ChatGPT Run' },
  },
}
