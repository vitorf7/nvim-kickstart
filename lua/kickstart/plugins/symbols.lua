return {
  'oskarrrrrrr/symbols.nvim',
  config = function()
    local r = require 'symbols.recipes'
    require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
      sidebar = {
        -- custom settings here
        -- e.g. hide_cursor = false
      },
    })
  end,
  keys = {
    { ',s', '<cmd>Symbols<CR>', desc = 'Symbols' },
    { ',S', '<cmd>SymbolsClose<CR>', desc = 'Symbols Close' },
  },
}
