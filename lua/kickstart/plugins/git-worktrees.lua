vim.g.git_worktree = {
  update_on_change_command = ':lua Snacks.dashboard.update()',
}
local Job = require 'plenary.job'
local strings = require 'plenary.strings'
local function get_os_command_output(cmd, cwd)
  if type(cmd) ~= 'table' then
    vim.notify('cmd has to be a table', 'ERROR')
    return {}
  end
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

return {
  'polarmutex/git-worktree.nvim',
  -- version = "^2",
  branch = 'main',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- using oil as default file explorer
    'stevearc/oil.nvim',
  },

  config = function()
    require('telescope').load_extension 'git_worktree'

    vim.keymap.set('n', '<Leader>gwM', function()
      local output = get_os_command_output { 'git', 'worktree', 'list' }
      ---@type snacks.picker.finder.Item[]
      local results = {}
      local bare_path = ''
      local current_path = vim.fn.getcwd()

      for _, line in ipairs(output) do
        local fields = vim.split(string.gsub(line, '%s+', ' '), ' ')
        local entry = {
          path = fields[1],
          sha = fields[2],
          branch = fields[3],
        }

        if entry.sha ~= '(bare)' then
          local index = #results + 1
          entry.idx = index

          table.insert(results, index, entry)
        else
          bare_path = entry.pathj
        end
      end

      local title = 'Git Worktrees'
      title = title:gsub('^%s*', ''):gsub('[%s:]*$', '')
      local layout = Snacks.picker.config.layout 'select'
      layout.preview = false
      layout.layout.height = math.floor(math.min(vim.o.lines * 0.8 - 10, #results + 2) + 0.5) + 10
      layout.layout.title = ' ' .. title .. ' '
      layout.layout.title_pos = 'center'

      Snacks.picker.pick {
        source = 'select',
        items = results,
        main = { current = true },
        format = function(item)
          ---@type string
          local path = string.gsub(item.path, bare_path .. '/', '')

          local ret = {} ---@type snacks.picker.Highlight[]
          ret[#ret + 1] = { ' ' }
          ret[#ret + 1] = { item.branch, 'SnacksPickerRegister' }
          ret[#ret + 1] = { ' ' }
          ret[#ret + 1] = { '(', 'SnacksPickerDelim' }
          ret[#ret + 1] = { item.sha, 'SnacksPickerRegister' }
          ret[#ret + 1] = { ')', 'SnacksPickerDelim' }
          ret[#ret + 1] = { ' ' }
          ret[#ret + 1] = { path, 'SnacksPickerRegister' }
          return ret
        end,
        actions = {
          confirm = function(picker, item)
            picker:close()
            vim.notify('Current path: ' .. current_path)
            vim.notify('Selected: ' .. vim.inspect(item))
            vim.notify('Idx: ' .. item.idx)

            vim.schedule(function()
              vim.notify('Switching to: ' .. item.path)
              require('git-worktree').switch_worktree(item.path)
              -- on_choice(item and item.item, item and item.idx)
            end)
          end,
        },
        layout = layout,
      }

      -- Snacks.picker.select(results, {
      --   prompt = 'Worktrees',
      --   format_item = function(item)
      --     return item.path
      --   end,
      -- }, function(item, idx)
      --   vim.notify('Selected: ' .. vim.inspect(item))
      --   vim.notify('Idx: ' .. idx)
      -- end)
    end, {
      desc = 'Manage',
    })

    vim.keymap.set('n', '<Leader>gwm', require('telescope').extensions.git_worktree.git_worktree, {
      desc = 'Manage',
    })
    vim.keymap.set('n', '<Leader>gwc', require('telescope').extensions.git_worktree.create_git_worktree, {
      desc = 'Create',
    })

    local Hooks = require 'git-worktree.hooks'

    Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
      print(prev_path .. '  ~>  ' .. path)
      if vim.fn.expand('%'):find '^oil:///' then
        require('oil').open(vim.fn.getcwd())
      else
        Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
      end
    end)
  end,
}
-- return {
--   'ThePrimeagen/git-worktree.nvim',
--   opts = {
--     update_on_change_command = ':lua Snacks.dashboard.update()',
--   },
--   config = function(_, opts)
--     require('git-worktree').setup(opts)
--     require('telescope').load_extension 'git_worktree'
--   end,
--   dependencies = {
--     'nvim-telescope/telescope.nvim',
--   },
--   --stylua: ignore
--   keys = {
--     {"<leader>gwm", function() require("telescope").extensions.git_worktree.git_worktrees() end, desc = "Manage"},
--     {"<leader>gwc", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "Create"},
--   },
-- }
