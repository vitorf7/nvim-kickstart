return {
  'rafaelsq/nvim-goc.lua',
  ft = 'go',
  config = function(_, opts)
    local goc = require 'nvim-goc'
    goc.setup(opts)

    vim.keymap.set('n', '<Leader>ccf', goc.Coverage, { desc = '[C]ode Go [C]overage [F]ile', silent = true }) -- run for the whole File
    vim.keymap.set('n', '<Leader>cct', goc.CoverageFunc, { desc = '[C]ode Go [C]overage [T]est', silent = true }) -- run only for a specific Test unit
    vim.keymap.set('n', '<Leader>ccc', goc.ClearCoverage, { desc = '[C]ode Go [C]lear [C]overage', silent = true }) -- clear coverage highlights
  end,
}
