local Util = require 'util'
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    opts = {
      ensure_installed = Util.parsers,
    },
    config = function(_, opts)
      local treesitter = require 'nvim-treesitter'
      treesitter.setup(opts)
      treesitter.install(opts.ensure_installed)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
            vim.treesitter.start(args.buf)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    opts = {
      select = {
        enable = true,
        lookahead = true,
      },
      move = {
        enable = true,
        set_jumps = true,
      },
      swap = {
        enable = true,
      },
    },
    config = function()
      -- goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
      --     goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
      --     goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
      --     goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },

      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Go to next start function' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']A', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.inner', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[A', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.inner', 'textobjects')
      end)

      vim.keymap.set({ 'x', 'o' }, 'af', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'aa', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ia', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects')
      end)

      -- vim.keymap.set('n', '<leader>a', function()
      --   require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
      -- end)
      -- vim.keymap.set('n', '<leader>A', function()
      --   require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.outer'
      -- end)
    end,
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      ensure_installed = Util.parsers,
      fold = { enable = true },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<A-o>',
          node_incremental = '<A-o>',
          scope_incremental = '<A-O>',
          node_decremental = '<A-i>',
        },
      },
    },
  },
}
