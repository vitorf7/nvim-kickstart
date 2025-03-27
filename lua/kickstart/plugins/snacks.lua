local function snack_or_disabled(snack_file_name)
  local disabled_snacks = {
    enabled = false,
  }

  local ok, _ = pcall(require, 'kickstart.plugins.snacks.' .. snack_file_name)
  if not ok then
    return disabled_snacks
  end

  return require('kickstart.plugins.snacks.' .. snack_file_name)
end

---@class snacks.Config
---@field animate? snacks.animate.Config
---@field bigfile? snacks.bigfile.Config
---@field bufdelete? snacks.bufdelete.Config
---@field dashboard? snacks.dashboard.Config
---@field debug? snacks.debug.Config
---@field dim? snacks.dim.Config
---@field explorer? snacks.explorer.Config
---@field git? snacks.git.Config
---@field gitbrowse? snacks.gitbrowse.Config
---@field input? snacks.input.Config
---@field indent? snacks.indent.Config
---@field lazygit? snacks.lazygit.Config
---@field notifier? snacks.notifier.Config
---@field notify? snacks.notify.Config
---@field picker? snacks.picker.Config
---@field profiler? snacks.profiler.Config
---@field quickfile? snacks.quickfile.Config
---@field rename? snacks.rename.Config
---@field scope? snacks.scope.Config
---@field scratch? snacks.scratch.Config
---@field scroll? snacks.scroll.Config
---@field statuscolumn? snacks.statuscolumn.Config
---@field terminal? snacks.terminal.Config
---@field toggle? snacks.toggle.Config
---@field win? snacks.win.Config
---@field words? snacks.words.Config
---@field zen? snacks.zen.Config
---@field styles? table<string, snacks.win.Config>
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    animate = snack_or_disabled 'animate',
    bigfile = snack_or_disabled 'bigfile',
    bufdelete = snack_or_disabled 'bufdelete',
    dashboard = snack_or_disabled 'dashboard',
    debug = snack_or_disabled 'debug',
    dim = snack_or_disabled 'dim',
    explorer = snack_or_disabled 'explorer',
    git = snack_or_disabled 'git',
    gitbrowse = snack_or_disabled 'gitbrowse',
    input = snack_or_disabled 'input',
    indent = snack_or_disabled 'indent',
    lazygit = snack_or_disabled 'lazygit',
    notifier = snack_or_disabled 'notifier',
    notify = snack_or_disabled 'notify',
    picker = snack_or_disabled 'picker',
    profiler = snack_or_disabled 'profiler',
    quickfile = snack_or_disabled 'quickfile',
    rename = snack_or_disabled 'rename',
    scope = snack_or_disabled 'scope',
    scratch = snack_or_disabled 'scratch',
    scroll = snack_or_disabled 'scroll',
    statuscolumn = snack_or_disabled 'statuscolumn',
    terminal = snack_or_disabled 'terminal',
    toggle = snack_or_disabled 'toggle',
    win = snack_or_disabled 'win',
    words = snack_or_disabled 'words',
    zen = snack_or_disabled 'zen',
    styles = {
      -- notification = {
      --   -- wo = { wrap = true } -- Wrap notifications
      -- },
    },
  },
  keys = {
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<c-_>',
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
    },

    -- Picker keys

    {
      '<leader>sh',
      desc = '[S]earch [H]elp',
      function()
        Snacks.picker.help()
      end,
    },
    {
      '<leader>sk',
      desc = '[S]earch [K]eymaps',
      function()
        Snacks.picker.keymaps()
      end,
    },
    {
      '<leader>sf',
      desc = '[S]earch [F]iles',
      function()
        Snacks.picker.files()
      end,
    },
    {
      '<leader>ss',
      desc = 'LSP [S]earch [S]ymbols',
      function()
        Snacks.picker.lsp_symbols()
      end,
    },
    {
      '<leader>sw',
      desc = '[S]earch current [W]ord',
      function()
        Snacks.picker.grep_word()
      end,
    },
    {
      '<leader>sg',
      desc = '[S]earch by [G]rep',
      function()
        Snacks.picker.grep {
          hide = true,
          ignored = true,
          cwd = Snacks.git.get_root(vim.api.nvim_buf_get_name(0)) or Snacks.git.get_root(vim.fn.expand '%:p') or vim.uv.cwd(),
        }
      end,
    },
    {
      '<leader>sd',
      desc = '[S]earch [D]iagnostics',
      function()
        Snacks.picker.diagnostics()
      end,
    },
    {
      '<leader>sR',
      desc = '[S]earch [R]esume',
      function()
        Snacks.picker.resume()
      end,
    },
    {
      '<leader>s.',
      desc = '[S]earch Recent Files ("." for repeat)',
      function()
        Snacks.picker.recent()
      end,
    },
    {
      '<leader><leader>',
      desc = '[] Find existing buffers',
      function()
        Snacks.picker.buffers()
      end,
    },
    {
      '<leader>/',
      desc = '[/] Fuzzily search in current buffer',
      function()
        Snacks.picker.lines()
      end,
    },
    {
      '<leader>s/',
      desc = '[S]earch [/] in Open Files',
      function()
        Snacks.picker.grep_buffers()
      end,
    },
    {
      '<leader>sn',
      desc = '[S]earch [N]eovim Config files',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
    },

    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    -- find
    {
      '<leader>fg',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    -- git
    {
      '<leader>fgd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff',
    },
    {
      '<leader>fgf',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Git Files',
    },
    {
      '<leader>fgl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Diff',
    },
    {
      '<leader>fgF',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },
    {
      '<leader>fgL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>fgs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    --search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man()
      end,
      desc = 'Man Pages',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
  },
  init = function(_, opts)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
        Snacks.toggle.zen():map '<leader>uz'
        Snacks.toggle.zoom():map '<leader>uZ'
      end,
    })
  end,
}
