return {
  {
    'Luxed/aw-watcher-nvim',
    cmd = 'AWStart',
    keys = {},
    opts = {},
    config = function(_, _)
      vim.g.aw_branch = true
    end,
  },
}
