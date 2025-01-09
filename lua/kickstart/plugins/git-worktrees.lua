return {
  'polarmutex/git-worktree.nvim',
  -- version = "^2",
  branch = 'main',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- using oil as default file explorer
    'stevearc/oil.nvim',
  },

  config = function()
    require('telescope').load_extension 'git_worktree'

    vim.keymap.set('n', '<Leader>gwm', require('telescope').extensions.git_worktree.git_worktree, {
      desc = 'Manage',
    })
    vim.keymap.set('n', '<Leader>gwc', require('telescope').extensions.git_worktree.create_git_worktree, {
      desc = 'Create',
    })

    local Hooks = require 'git-worktree.hooks'

    Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
      print(prev_path .. '  ~>  ' .. path)
      if vim.fn.expand('%'):find '^oil:///' then
        require('oil').open(vim.fn.getcwd())
      else
        Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
      end
    end)
  end,
}
-- return {
--   'ThePrimeagen/git-worktree.nvim',
--   opts = {
--     update_on_change_command = ':lua Snacks.dashboard.update()',
--   },
--   config = function(_, opts)
--     require('git-worktree').setup(opts)
--     require('telescope').load_extension 'git_worktree'
--   end,
--   dependencies = {
--     'nvim-telescope/telescope.nvim',
--   },
--   --stylua: ignore
--   keys = {
--     {"<leader>gwm", function() require("telescope").extensions.git_worktree.git_worktrees() end, desc = "Manage"},
--     {"<leader>gwc", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "Create"},
--   },
-- }
