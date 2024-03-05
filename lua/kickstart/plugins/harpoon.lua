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
      harpoon:list():append()
    end, { desc = 'Harpoon: Add to list' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle list' })

    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<C-m>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-<>', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<C->>', function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-K>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-J>', function()
      harpoon:list():next()
    end)
  end,
}
