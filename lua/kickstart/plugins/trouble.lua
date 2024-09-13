return {
  'folke/trouble.nvim',
  cmd = { 'TroubleToggle', 'Trouble' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    use_diagnostic_signs = true, -- refer to the configuration section below
  },
  keys = {
    { '<leader>st', '<cmd>Trouble<cr>', desc = '[S]earch [T]rouble' },
    {
      '[q',
      function()
        if require('trouble').is_open() then
          require('trouble').previous { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Previous trouble/quickfix item',
    },
    {
      ']q',
      function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Next trouble/quickfix item',
    },
  },
}
