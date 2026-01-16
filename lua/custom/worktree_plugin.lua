-- ~/.config/nvim/lua/kickstart/plugins/worktree.lua
-- Git Worktree Manager for Neovim with Snacks Picker

-- The actual plugin code
local M = {}

-- Utility function to execute git commands
local function git_cmd(args, opts)
  opts = opts or {}
  local cmd = vim.list_extend({ 'git' }, args)
  local result = vim.fn.systemlist(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    if not opts.ignore_error then
      vim.notify('Git command failed: ' .. table.concat(result, '\n'), vim.log.levels.ERROR)
    end
    return nil
  end

  return result
end

local function get_repo_root_dir()
  local out = git_cmd({ 'worktree', 'list', '--porcelain' }, { ignore_error = true })
  if not out then
    return nil
  end

  for _, line in ipairs(out) do
    local wt = line:match '^worktree (.+)$'
    if wt then
      -- just the main worktree directory
      return vim.fn.fnamemodify(wt, ':p:h')
    end
  end

  return nil
end

local function get_repo_container_dir()
  local out = git_cmd({ 'worktree', 'list', '--porcelain' }, { ignore_error = true })
  if not out then
    return nil
  end

  for _, line in ipairs(out) do
    local wt = line:match '^worktree (.+)$'
    if wt then
      -- parent of main worktree
      return vim.fn.fnamemodify(wt, ':p:h:h')
    end
  end

  return nil
end

local function path_from_repo_container(worktree_path)
  local base = get_repo_container_dir()
  if not base then
    return vim.fn.fnamemodify(worktree_path, ':~')
  end

  base = vim.fn.fnamemodify(base, ':p')
  local wt = vim.fn.fnamemodify(worktree_path, ':p')

  if not base:match '/$' then
    base = base .. '/'
  end

  if vim.startswith(wt, base) then
    local rel = wt:sub(#base + 1)
    return rel ~= '' and rel or vim.fn.fnamemodify(worktree_path, ':t')
  end

  return vim.fn.fnamemodify(worktree_path, ':~')
end

-- Parse worktree list output
local function parse_worktrees()
  local output = git_cmd { 'worktree', 'list', '--porcelain' }
  if not output then
    return {}
  end

  local worktrees = {}
  local current_item = { current = false }

  for _, line in ipairs(output) do
    if line:match '^worktree ' then
      current_item.path = line:match '^worktree (.+)$'
    elseif line:match '^HEAD ' then
      current_item.head = line:match '^HEAD (.+)$'
    elseif line:match '^branch ' then
      current_item.branch = line:match '^branch refs/heads/(.+)$'
    elseif line:match '^detached' then
      current_item.detached = true
    elseif line == '' and current_item.path then
      table.insert(worktrees, current_item)
      current_item = {}
    elseif vim.fn.fnamemodify(vim.fn.getcwd(), ':p') == vim.fn.fnamemodify(current_item.path, ':p') then
      current_item.current = true
    end
  end

  -- Add last entry if exists
  if current_item.path then
    table.insert(worktrees, current_item)
  end

  return worktrees
end

-- Format worktree for display in picker
local function format_worktree(wt)
  local marker = wt.current and '󰄳 ' or '  '
  local branch = wt.branch or (wt.detached and 'DETACHED') or 'bare'
  local sha = wt.head and wt.head:sub(1, 8) or ''
  local path = path_from_repo_container(wt.path)

  return string.format('%s%-30s %-25s %-8s', marker, path, branch, sha)
end

-- Switch to worktree directory
local function switch_to_worktree(picker, worktree)
  vim.cmd('cd ' .. vim.fn.fnameescape(worktree.path))
  vim.notify('Switched to worktree: ' .. worktree.path, vim.log.levels.INFO)

  -- Close picker
  picker:close()
end

-- Create new worktree
function M.create_worktree()
  -- Get available branches
  local branches = git_cmd { 'branch', '-a', '--format=%(refname:short)' }
  if not branches then
    return
  end

  -- Remove duplicates and clean branch names
  local seen = {}
  local clean_branches = {}
  for _, branch in ipairs(branches) do
    local clean = branch:gsub('^remotes/[^/]+/', '')
    if not seen[clean] then
      seen[clean] = true
      table.insert(clean_branches, clean)
    end
  end

  -- Ask user to select base branch
  vim.ui.select(clean_branches, {
    prompt = 'Select base branch: ',
  }, function(base_branch)
    if not base_branch then
      return
    end

    -- Ask for new branch name
    vim.ui.input({
      prompt = 'New branch name (leave empty to checkout existing): ',
      default = '',
    }, function(new_branch)
      if new_branch == nil then
        return
      end

      -- Ask for worktree directory
      local repo_base = get_repo_root_dir()
      local default_path = repo_base and (repo_base .. '/') or './'
      local suggested_dir = default_path
      if new_branch ~= '' then
        suggested_dir = vim.fn.fnamemodify(default_path, ':p') .. new_branch
      end

      vim.ui.input({
        prompt = 'Worktree directory: ',
        default = suggested_dir,
        completion = 'dir',
      }, function(wt_path)
        if not wt_path then
          return
        end

        -- Expand path
        wt_path = vim.fn.expand(wt_path)

        -- Build git worktree add command
        local cmd_args = { 'worktree', 'add' }

        if new_branch ~= '' then
          table.insert(cmd_args, '-b')
          table.insert(cmd_args, new_branch)
        end

        table.insert(cmd_args, wt_path)
        table.insert(cmd_args, base_branch)

        -- Execute command
        local result = git_cmd(cmd_args)
        if result then
          vim.notify('Worktree created successfully', vim.log.levels.INFO)
          -- Switch to new worktree
          vim.cmd('cd ' .. vim.fn.fnameescape(wt_path))
        end
      end)
    end)
  end)
end

-- Delete worktree
local function delete_worktree(picker, worktree)
  if not worktree or not worktree.path then
    vim.notify('Invalid worktree: ' .. vim.inspect(worktree), vim.log.levels.ERROR)
    return
  end

  local display = format_worktree(worktree)

  -- First check if worktree is dirty or locked
  -- Change to the worktree directory to check its status
  local current_dir = vim.fn.getcwd()
  vim.cmd('cd ' .. vim.fn.fnameescape(worktree.path))

  local status_result = git_cmd({ 'status', '--porcelain' }, { ignore_error = true })
  local is_dirty = status_result and #status_result > 0

  -- Return to original directory
  vim.cmd('cd ' .. vim.fn.fnameescape(current_dir))

  -- Check if locked (worktree list shows locked status)
  local worktree_info = git_cmd({ 'worktree', 'list', '--porcelain' }, { ignore_error = true })
  local is_locked = false
  if worktree_info then
    local in_target = false
    for _, line in ipairs(worktree_info) do
      if line:match '^worktree ' and line:find(worktree.path, 1, true) then
        in_target = true
      elseif in_target and line:match '^locked' then
        is_locked = true
        break
      elseif in_target and line == '' then
        break
      end
    end
  end

  vim.ui.select({ 'Yes', 'No' }, {
    prompt = 'Delete worktree: ' .. display .. '?',
  }, function(confirm)
    if confirm ~= 'Yes' then
      return
    end

    local function do_delete(force)
      local cmd_args = { 'worktree', 'remove' }
      if force then
        table.insert(cmd_args, '--force')
      end
      table.insert(cmd_args, worktree.path)

      local result = git_cmd(cmd_args, { ignore_error = true })
      if not result then
        vim.notify('Failed to delete worktree', vim.log.levels.ERROR)
        return false
      end

      vim.notify('Worktree deleted: ' .. worktree.path, vim.log.levels.INFO)
      return true
    end

    local function finish_deletion()
      -- Ask about deleting branch
      if worktree.branch then
        vim.ui.select({ 'Yes', 'No' }, {
          prompt = "Delete branch '" .. worktree.branch .. "' as well?",
        }, function(delete_branch)
          if delete_branch == 'Yes' then
            git_cmd { 'branch', '-D', worktree.branch }
            vim.notify('Branch deleted: ' .. worktree.branch, vim.log.levels.INFO)
          end

          -- Close and refresh picker
          picker:close()
          vim.schedule(function()
            M.manage()
          end)
        end)
      else
        -- No branch to delete, just close and refresh
        picker:close()
        vim.schedule(function()
          M.manage()
        end)
      end
    end

    -- Check if we need to force delete
    if is_dirty or is_locked then
      local reason = is_locked and 'locked' or 'dirty (has uncommitted changes)'
      vim.ui.select({ 'Yes', 'No' }, {
        prompt = 'Worktree is ' .. reason .. '. Force delete?',
      }, function(force_confirm)
        if force_confirm == 'Yes' then
          if do_delete(true) then
            finish_deletion()
          else
            picker:close()
          end
        else
          picker:close()
        end
      end)
    else
      -- Clean worktree, delete normally
      if do_delete(false) then
        finish_deletion()
      else
        picker:close()
      end
    end
  end)
end

-- Format worktree for display in picker with highlights
local function format_worktree_picker(item, ctx)
  local a = require('snacks').picker.util.align
  local ret = {} ---@type snacks.picker.Highlight[]

  local wt = item.worktree
  if not wt then
    return { { item.text or '' } }
  end

  local win = ctx and ctx.win or 0
  local total = vim.api.nvim_win_get_width(win > 0 and win or 0)

  -- column sizing (responsive)
  local marker_w = 2
  local sha_w = 8
  local path_w = math.max(35, math.floor(total * 0.5))
  -- local branch_w = math.max(14, math.floor(total * 0.25))
  local branch_w = math.max(14, total - (marker_w + path_w + sha_w + 6))

  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
  local is_current = cwd == vim.fn.fnamemodify(wt.path, ':p')

  -- 1. current marker
  if is_current then
    ret[#ret + 1] = { a('󰄳 ', marker_w), 'SnacksPickerGitBranchCurrent' }
  else
    ret[#ret + 1] = { a('  ', marker_w) }
  end

  -- 2. relative path (dimmed)
  local relpath = item.relpath
  ret[#ret + 1] = {
    a(relpath, path_w, { truncate = true }),
    'Comment',
  }

  ret[#ret + 1] = { ' ' }

  -- 3. branch
  local branch = wt.branch or (wt.detached and 'DETACHED') or 'bare'
  ret[#ret + 1] = {
    a(branch, branch_w, { truncate = true }),
    'SnacksPickerGitBranch',
  }

  ret[#ret + 1] = { ' ' }

  -- 4. commit
  local sha = wt.head and wt.head:sub(1, 8) or ''
  ret[#ret + 1] = {
    a(sha, sha_w),
    'SnacksPickerGitCommit',
  }

  return ret
end

-- Main worktree picker
function M.manage()
  local snacks_ok, snacks = pcall(require, 'snacks')
  if not snacks_ok then
    vim.notify('Snacks.nvim is required for this plugin', vim.log.levels.ERROR)
    return
  end

  local worktrees = parse_worktrees()
  if #worktrees == 0 then
    vim.notify('No worktrees found', vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, wt in ipairs(worktrees) do
    -- Skip bare worktrees (those without a branch and not detached)
    if wt.branch or wt.detached then
      table.insert(items, {
        file = wt.path,
        text = format_worktree(wt), -- Fallback text
        worktree = wt,
        relpath = path_from_repo_container(wt.path),
      })
    end
  end

  if #items == 0 then
    vim.notify('No non-bare worktrees found', vm.log.levels.WARN)
    return
  end

  snacks.picker.pick {
    prompt = 'Git Worktrees ',
    items = items,
    preview = false,
    format = format_worktree_picker,
    confirm = function(picker, item)
      if item and item.worktree then
        switch_to_worktree(picker, item.worktree)
      end
    end,
    actions = {
      delete_worktree_action = function(picker)
        local item = picker:current()
        if item and item.worktree then
          delete_worktree(picker, item.worktree)
        end
      end,
    },
    win = {
      input = {
        keys = {
          ['<c-d>'] = { 'delete_worktree_action', mode = { 'n', 'i' } },
        },
      },
    },
  }
end

-- Switch to worktree (quick switch without management options)
function M.switch()
  local snacks_ok, snacks = pcall(require, 'snacks')
  if not snacks_ok then
    vim.notify('Snacks.nvim is required for this plugin', vim.log.levels.ERROR)
    return
  end

  local worktrees = parse_worktrees()
  if #worktrees == 0 then
    vim.notify('No worktrees found', vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, wt in ipairs(worktrees) do
    -- Skip bare worktrees
    if wt.branch or wt.detached then
      table.insert(items, {
        file = wt.path,
        text = format_worktree(wt),
        worktree = wt,
        relpath = path_from_repo_container(wt.path),
      })
    end
  end

  if #items == 0 then
    vim.notify('No non-bare worktrees found', vim.log.levels.WARN)
    return
  end

  snacks.picker.pick {
    prompt = 'Switch Worktree ',
    items = items,
    preview = false,
    format = format_worktree_picker,
    on_select = function(item, ctx)
      if item and item.worktree then
        switch_to_worktree(ctx.picker, item.worktree)
      end
    end,
  }
end

-- List all worktrees (read-only view)
function M.list()
  local worktrees = parse_worktrees()
  if #worktrees == 0 then
    vim.notify('No worktrees found', vim.log.levels.WARN)
    return
  end

  local lines = {}
  for _, wt in ipairs(worktrees) do
    table.insert(lines, format_worktree(wt))
  end

  -- create scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'gitworktrees')

  -- open floating window
  local width = math.min(120, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 6)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })
end

-- Setup function for easy configuration
function M.setup(opts)
  opts = opts or {}

  -- Create user commands
  vim.api.nvim_create_user_command('GitWorktreeManage', M.manage, {})
  vim.api.nvim_create_user_command('GitWorktreeSwitch', M.switch, {})
  vim.api.nvim_create_user_command('GitWorktreeCreate', M.create_worktree, {})
  vim.api.nvim_create_user_command('GitWorktreeList', M.list, {})

  -- Set up keymaps if provided
  if opts.keymaps then
    for key, action in pairs(opts.keymaps) do
      if M[action] then
        vim.keymap.set('n', key, M[action], { desc = 'Git Worktree: ' .. action })
      end
    end
  end
end

return M
