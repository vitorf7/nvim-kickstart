local Util = require 'util'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- lazygit
-- keymap('n', '<leader>gg', function()
--   Util.terminal({ 'lazygit' }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
-- end, { desc = 'Lazygit (root dir)' })

-- czg Git
keymap('n', '<leader>gc', function()
  Util.terminal({ 'czg' }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
end, { desc = 'czg (root dir)' })

-- Terminal
-- local lazyterm = function()
--   Util.terminal(nil, { cwd = Util.root() })
-- end
-- keymap('n', '<c-/>', lazyterm, { desc = 'Terminal (root dir)' })
-- keymap('n', '<c-_>', lazyterm, { desc = 'which_key_ignore' })

-- Terminal Mappings
keymap('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
keymap('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
keymap('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
keymap('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
keymap('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
keymap('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
keymap('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- Diagnostic keymaps
keymap('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
keymap('n', '[q', vim.cmd.cprev, { desc = 'Previous [Q]uickfix' })
keymap('n', ']q', vim.cmd.cnext, { desc = 'Next [Q]uickfix' })
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
keymap('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity[vim.diagnostic.severity.ERROR] }
end, { desc = 'Go to press Diagnostic [E]rror' })
keymap('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity[vim.diagnostic.severity.ERROR] }
end, { desc = 'Go to next Diagnostic [E]rror' })
keymap('n', '[w', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity[vim.diagnostic.severity.WARN] }
end, { desc = 'Go to press Diagnostic [W]arning' })
keymap('n', ']w', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity[vim.diagnostic.severity.WARN] }
end, { desc = 'Go to next Diagnostic [W]arning' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Normal --
-- Better window navigation (Use nvim tmux navigation)
keymap('n', '<C-h>', ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
keymap('n', '<C-j>', ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
keymap('n', '<C-k>', ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
keymap('n', '<C-l>', ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)
keymap('n', '<C-\\>', ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLastActive()<cr>", opts)
keymap('n', '<C-Space>', ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateNext()<cr>", opts)

-- Save buffer
keymap('n', '<C-s>', ':w!<CR>', opts)
keymap('n', '<C-S-s>', ':wa!<CR>', opts)
keymap('n', '<leader>w', ':w!<CR>', vim.tbl_extend('force', opts, { desc = 'Save buffer' }))

-- Move text up and down
keymap('n', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('n', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)

-- Better paste
keymap('v', 'p', 'P', opts)

-- Insert --
-- Press jk fast to enter
keymap('i', 'jk', '<ESC>', opts)
keymap('i', 'jj', '<ESC>', opts)

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', '<A-j>', ':m .+1<CR>==', opts)
keymap('v', '<A-k>', ':m .-2<CR>==', opts)

-- Visual Block --
-- Move text up and down
keymap('x', 'J', ":move '>+1<CR>gv-gv", opts)
keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

-- Close all buffers except current
-- keymap('n', '<leader>q', ':%bd|e#|bd#<cr>', vim.tbl_extend('force', opts, { desc = 'Close all buffers except current' }))
-- Buffers
keymap('n', '<C-q>', function()
  Snacks.bufdelete.delete()
end, vim.tbl_extend('force', opts, { desc = 'Close current buffer' }))
keymap('n', '<leader>q', function()
  Snacks.bufdelete.other()
end, vim.tbl_extend('force', opts, { desc = 'Close all buffers except current' }))
