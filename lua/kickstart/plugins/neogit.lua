local Util = require 'util'
return {
  'NeogitOrg/neogit',
  enabled = false,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
  config = function()
    require('neogit').setup {
      integrations = {
        -- If enabled, use telescope for menu selection rather than vim.ui.select.
        -- Allows multi-select and some things that vim.ui.select doesn't.
        telescope = false,
        -- If enabled, uses fzf-lua for menu selection. If the telescope integration
        -- is also selected then telescope is used instead
        -- Requires you to have `ibhagwan/fzf-lua` installed.
        fzf_lua = false,

        -- If enabled, uses mini.pick for menu selection. If the telescope integration
        -- is also selected then telescope is used instead
        -- Requires you to have `echasnovski/mini.pick` installed.
        mini_pick = false,
      },
    }
  end,
  keys = {
    { '<leader>gG', '<cmd>Neogit<cr>', desc = 'Neogit' },
  },
}
