-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- vim.cmd [[command! -nargs=0 GoToCommand :Telescope commands]]
vim.cmd [[command! -nargs=0 GoToCommand :lua Snacks.picker.commands()]]
-- vim.cmd [[command! -nargs=0 GoToFile :Telescope smart_open]]
vim.cmd [[command! -nargs=0 GoToFile :lua Snacks.picker.pick("smart")]]
-- vim.cmd [[command! -nargs=0 Grep :Telescope live_grep]]
vim.cmd [[command! -nargs=0 Grep :lua Snacks.picker.grep()]]
vim.cmd [[command! -nargs=0 BrowseFiles :lua require('kickstart.config.modules.mini-files-explorer').open()]]
vim.cmd [[command! -nargs=0 GenNvim :Gen]]

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  ui = {
    backdrop = 100,
  },
  spec = {
    { import = 'kickstart.plugins' },
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
