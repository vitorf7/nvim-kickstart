---@class util: LazyUtilCore
---@field lsp util.lsp
---@field root util.root
---@field terminal util.terminal
---@field icons util.icons
---@field servers string[]
---@field linters string[]
---@field parsers string[]
---@field mason_tools string[]
local M = {}

---@type table<string, string|string[]>
local deprecated = {
  get_clients = 'lsp',
  on_attach = 'lsp',
  on_rename = 'lsp',
  root_patterns = { 'root', 'patterns' },
  get_root = { 'root', 'get' },
  float_term = { 'terminal', 'open' },
  toggle_diagnostics = { 'toggle', 'diagnostics' },
  toggle_number = { 'toggle', 'number' },
  fg = 'ui',
}

---@class util.icons
M.icons = {
  misc = {
    dots = '󰇘',
  },
  dap = {
    Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Codeium = '󰘦 ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = ' ',
    String = ' ',
    Struct = '󰆼 ',
    TabNine = '󰏚 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}

setmetatable(M, {
  __index = function(t, k)
    local dep = deprecated[k]
    if dep then
      local mod = type(dep) == 'table' and dep[1] or dep
      local key = type(dep) == 'table' and dep[2] or k
      M.deprecate([[require("util").]] .. k, [[require("util").]] .. mod .. '.' .. key)
      ---@diagnostic disable-next-line: no-unknown
      t[mod] = require('util.' .. mod) -- load here to prevent loops
      return t[mod][key]
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('util.' .. k)
    return t[k]
  end,
})

---@type string[]
M.servers = {
  'lua_ls',
  'cssls',
  'html',
  'ts_ls',
  'vtsls',
  'eslint',
  'pyright',
  'bashls',
  'jsonls',
  'llm-ls',
  'yamlls',
  'gopls',
  'graphql',
  'phpactor',
  'intelephense',
  'terraformls',
  'tflint',
  'buf_ls',
  'cucumber_language_server',
  'dockerls',
  'marksman',
  'dockerls',
  'docker_compose_language_service',
  'golangci_lint_ls',
  'taplo',
  'ansiblels',
  'jinja_lsp',
  'harper_ls',
}

---@type string[]
M.linters = {
  'buf',
  'hadolint',
  'markdownlint',
  'misspell',
  'phpcs',
  'tflint',
  'yamllint',
  'prettier',
  'stylua',
}

---@type string[]
M.parsers = {
  'bash',
  'cmake',
  'css',
  'dockerfile',
  'dot',
  'hcl',
  'html',
  'http',
  'javascript',
  'json',
  'json5',
  'jsonc',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'php',
  'phpdoc',
  'proto',
  'python',
  'query',
  'scss',
  'sql',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'yaml',
  'terraform',
  'go',
  'godot_resource',
  'gomod',
  'gosum',
  'gowork',
  'toml',
}

---@type string[]
M.mason_tools = {
  --DAP
  'delve',
  'js-debug-adapter',
  'php-debug-adapter',

  -- Linter
  'buf', -- also a formatter
  'hadolint',
  'markdownlint', -- also a formatter
  'misspell',
  'phpcs',
  'tflint',
  'yamllint',
  'golangci-lint',
  'jsonlint',

  -- Formatter
  'gci',
  'gofumpt',
  'goimports',
  'golines',
  'prettier',
  'prettierd',
  'stylua',
  'yamlfmt',
  'black',
  'php-cs-fixer',
  'ts-standard',

  -- Other tools
  'gotests',
  'gomodifytags',
  'iferr',
  'impl',
  'gotestsum',
}

---@param plugin string
function M.has(plugin)
  return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require('lazy.core.config').plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

function M.deprecate(old, new)
  M.warn(('`%s` is deprecated. Please use `%s` instead'):format(old, new), {
    title = 'LazyVim',
    once = true,
    stacktrace = true,
    stacklevel = 6,
  })
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = assert(vim.loop.new_check())

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require 'lazy.core.config'
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require('lazy.core.handler').handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == 'string' and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

---@param name string
---@return string
function M.normname(name)
  local ret = name:lower():gsub('^n?vim%-', ''):gsub('%.n?vim$', ''):gsub('%.lua', ''):gsub('[^a-z]+', '')
  return ret
end

---@return string
function M.norm(path)
  if path:sub(1, 1) == '~' then
    local home = vim.loop.os_homedir()
    if home:sub(-1) == '\\' or home:sub(-1) == '/' then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub('\\', '/'):gsub('/+', '/')
  return path:sub(-1) == '/' and path:sub(1, -2) or path
end

function M.is_win()
  return vim.loop.os_uname().sysname:find 'Windows' ~= nil
end

local function can_merge(v)
  return type(v) == 'table' and (vim.tbl_isempty(v) or not M.is_list(v))
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
--- Supports clearing values by setting a key to `vim.NIL`
---@generic T
---@param ... T
---@return T
function M.merge(...)
  local ret = select(1, ...)
  if ret == vim.NIL then
    ret = nil
  end
  for i = 2, select('#', ...) do
    local value = select(i, ...)
    if can_merge(ret) and can_merge(value) then
      for k, v in pairs(value) do
        ret[k] = M.merge(ret[k], v)
      end
    elseif value == vim.NIL then
      ret = nil
    elseif value ~= nil then
      ret = value
    end
  end
  return ret
end

---@param builtin string
---@param opts? table
---@return function
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend('force', { cwd = require('util').root() }, opts or {})

    require('telescope.builtin')[builtin](opts)
  end
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, 'mason') -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath 'data' .. '/mason')
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ''
  local ret = root .. '/packages/' .. pkg .. '/' .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require('lazy.core.config').headless() then
    M.warn(('Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package.'):format(pkg, path))
  end
  return ret
end

return M
