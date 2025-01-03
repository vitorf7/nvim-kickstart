return {
  enabled = true,
  preset = {
    keys = {
      { icon = ' ', key = 'e', desc = 'Explore Directory', action = ':Neotree toggle' },
      { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
      { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
      { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
      { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
      { icon = ' ', key = 'u', desc = 'Update Mason', action = ':Mason' },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
    -- header = [[
    --   ██╗      ██████╗ ██████╗ ██████╗     ██╗   ██╗██╗████████╗ ██████╗ ██████╗ ███████╗███████╗
    --   ██║     ██╔═══██╗██╔══██╗██╔══██╗    ██║   ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝╚════██║
    --   ██║     ██║   ██║██████╔╝██║  ██║    ██║   ██║██║   ██║   ██║   ██║██████╔╝█████╗      ██╔╝
    --   ██║     ██║   ██║██╔══██╗██║  ██║    ╚██╗ ██╔╝██║   ██║   ██║   ██║██╔══██╗██╔══╝     ██╔╝
    --   ███████╗╚██████╔╝██║  ██║██████╔╝     ╚████╔╝ ██║   ██║   ╚██████╔╝██║  ██║██║        ██║
    --   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝       ╚═══╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝        ╚═╝
    -- ]],
    header = [[
 _     _________________   _   _ _____ _____ _________________ ______
| |   |  _  | ___ \  _  \ | | | |_   _|_   _|  _  | ___ \  ___|___  /
| |   | | | | |_/ / | | | | | | | | |   | | | | | | |_/ / |_     / / 
| |   | | | |    /| | | | | | | | | |   | | | | | |    /|  _|   / /  
| |___\ \_/ / |\ \| |/ /  \ \_/ /_| |_  | | \ \_/ / |\ \| |   ./ /   
\_____/\___/\_| \_|___/    \___/ \___/  \_/  \___/\_| \_\_|   \_/    
]],
  },
  formats = {
    header = {
      align = 'center',
    },
  },
  sections = {
    { section = 'header' },
    { section = 'keys', gap = 1, padding = 1 },
    { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
    { section = 'startup' },
    {
      section = 'terminal',
      cmd = 'pokemon-colorscripts -r 1 --no-title; sleep .1',
      random = 10,
      pane = 2,
      indent = 4,
      height = 20,
    },
    function()
      local in_git = Snacks.git.get_root() ~= nil
      local cmds = {
        {
          icon = ' ',
          title = 'Git Status',
          cmd = 'git --no-pager diff --stat -B -M -C',
          height = 10,
        },
        {
          title = 'Notifications',
          cmd = 'gh notify -s -a -n3',
          icon = ' ',
          height = 3,
          enabled = true,
        },
      }
      return vim.tbl_map(function(cmd)
        return vim.tbl_extend('force', {
          pane = 2,
          section = 'terminal',
          enabled = in_git,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        }, cmd)
      end, cmds)
    end,
  },
}
