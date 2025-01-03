return {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>ue',
      function()
        require('edgy').toggle()
      end,
      desc = '[U]i [E]dgy Toggle',
    },
  },
  opts = function()
    local opts = {
      options = {
        right = {
          size = 40,
        },
      },
      bottom = {
        {
          ft = 'snacks_terminal',
          size = { height = 0.4 },
          title = '%{b:snacks_terminal.id}: %{b:term_title}',
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == 'bottom'
              and vim.w[win].snacks_win.relative == 'editor'
              and not vim.w[win].trouble_preview
          end,
        },
        {
          ft = 'toggleterm',
          size = { height = 0.4 },
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        {
          ft = 'noice',
          size = { height = 0.4 },
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        {
          ft = 'lazyterm',
          title = 'Terminal',
          size = { height = 0.4 },
          filter = function(buf)
            return not vim.b[buf].lazyterm_cmd
          end,
        },
        'Trouble',
        {
          ft = 'trouble',
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        { ft = 'qf', title = 'QuickFix' },
        {
          ft = 'help',
          size = { height = 20 },
          -- don't open help files in edgy that we're editing
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
        { title = 'Neotest Output', ft = 'neotest-output-panel', size = { height = 15 } },
        { title = 'Spectre', ft = 'spectre_panel', size = { height = 0.4 } },
      },
      left = {
        {
          title = 'Neo-Tree',
          ft = 'neo-tree',
          filter = function(buf)
            return vim.b[buf].neo_tree_source == 'filesystem'
          end,
          pinned = true,
          open = function()
            vim.api.nvim_input '<esc><space>e'
          end,
        },
      },
      right = {},
      keys = {
        -- increase width
        ['<c-Right>'] = function(win)
          win:resize('width', 2)
        end,
        -- decrease width
        ['<c-Left>'] = function(win)
          win:resize('width', -2)
        end,
        -- increase height
        ['<c-Up>'] = function(win)
          win:resize('height', 2)
        end,
        -- decrease height
        ['<c-Down>'] = function(win)
          win:resize('height', -2)
        end,
      },
      animate = {
        enabled = false,
      },
    }
    return opts
  end,
}
