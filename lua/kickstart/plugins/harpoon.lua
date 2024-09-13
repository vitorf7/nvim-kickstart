return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Add to list' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle list' })

    for i = 1, 5 do
      vim.keymap.set('n', '<leader>' .. i, function()
        harpoon:list():select(i)
      end, { desc = '[H]arpoon: Select [' .. i .. '] from list' })
    end

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-K>', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon: Previous buffer from list' })
    vim.keymap.set('n', '<C-S-J>', function()
      harpoon:list():next()
    end, { desc = 'Harpoon: Next buffer from list' })
  end,
}
