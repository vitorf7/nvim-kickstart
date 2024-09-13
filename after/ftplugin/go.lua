local map = function(mode, lhs, rhs, desc)
  if desc then
    desc = desc
  end

  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, noremap = true, nowait = true })
end
map('n', '<leader>ci', '<cmd>GoInstallDeps<Cr>', 'Install Go Dependencies')
map('n', '<leader>cm', '<cmd>GoMod tidy<cr>', 'Go Mod Tidy')
map('n', '<leader>cta', '<cmd>GoTestAdd<Cr>', 'Test: Add (current method)')
map('n', '<leader>ctA', '<cmd>GoTestsAll<Cr>', 'Test: Add All')
map('n', '<leader>cte', '<cmd>GoTestsExp<Cr>', 'Test: Add Exported Tests')
map('n', '<leader>cg', '<cmd>GoGenerate<Cr>', 'Go Generate')
map('n', '<leader>cf', '<cmd>GoGenerate %<Cr>', 'Go Generate File')
map('n', '<leader>cC', '<cmd>GoCmt<Cr>', 'Generate Comment')
map('n', '<leader>cl', '<cmd>! golines % -w --base-formatter="gofumpt" --ignore-generated --max-len=140<Cr><Cr>', 'Golines Fix Current File')
map('n', '<leader>td', "<cmd>lua require('dap-go').debug_test()<cr>", 'Debug Test (Dap go)')
