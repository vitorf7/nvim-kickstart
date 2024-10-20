return {
  'andythigpen/nvim-coverage',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>tc', '<cmd>CoverageToggle<cr>', desc = 'Coverage in gutter' },
    { '<leader>tC', '<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>', desc = 'Coverage summary' },
  },
  opts = {
    highlights = {
      -- customize highlight groups created by the plugin
      covered = { fg = '#C3E88D' }, -- supports style, fg, bg, sp (see :h highlight-gui)
      uncovered = { fg = '#F07178' },
    },
    signs = {
      -- use your own highlight groups or text markers
      covered = { hl = 'CoverageCovered', text = '▎' },
      uncovered = { hl = 'CoverageUncovered', text = '▎' },
    },
    auto_reload = true,
    lang = {
      go = {
        coverage_file = vim.fn.getcwd() .. '/coverage.out',
      },
    },
  },
}
