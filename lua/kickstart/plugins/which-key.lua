return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VeryLazy', -- Sets the loading event to 'VeryLazy'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').add {
      {
        '<leader>a',
        function()
          Snacks.dashboard.open()
        end,
        desc = 'D[a]shboard',
      },

      { '<leader>A', group = '[A]I' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>g', group = '[G]it' },
      { '<leader>gw', group = '[G]it [W]orktrees' },
      { '<leader>l', group = '[L]SP' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]est' },
      { '<leader>u', group = '[U]I' },
      { '<leader>w', group = '[W]orkspace' },

      -- gh.nvim keys
      { '<leader>gh', group = '[G]it[H]ub' },
      { '<leader>ghc', group = '+[C]ommits' },
      { '<leader>ghi', group = '+[I]ssues' },
      { '<leader>ghl', group = '+[L]itee' },
      { '<leader>ghr', group = '+[R]eview' },
      { '<leader>ghp', group = '+[P]ull Request' },
      { '<leader>ght', group = '+[T]hreads' },
    }
  end,
}
