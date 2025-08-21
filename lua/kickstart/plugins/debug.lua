-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    {
      'igorlfs/nvim-dap-view',
      ---@module 'dap-view'
      ---@type dapview.Config
      opts = {
        winbar = {
          controls = {
            enabled = true,
          },
        },
      },
    },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function(_, opts)
    local dap = require 'dap'
    local dapui = require 'dapui'

    for name, sign in pairs(require('util').icons.dap) do
      sign = type(sign) == 'table' and sign or { sign }
      vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
    end

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    -- vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    -- vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    -- vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    -- vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    -- vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    -- vim.keymap.set('n', '<leader>B', function()
    --   dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    -- end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    -- dapui.setup {
    --   -- Set icons to characters that are more likely to work in every terminal.
    --   --    Feel free to remove or use ones that you like more! :)
    --   --    Don't feel like these are good choices.
    --   icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    --   controls = {
    --     icons = {
    --       pause = '⏸',
    --       play = '▶',
    --       step_into = '⏎',
    --       step_over = '⏭',
    --       step_out = '⏮',
    --       step_back = 'b',
    --       run_last = '▶▶',
    --       terminate = '⏹',
    --       disconnect = '⏏',
    --     },
    --   },
    -- }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    -- vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()

    if not dap.adapters['pwa-node'] then
      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          -- 💀 Make sure to update this path to point to your installation
          args = {
            require('util').get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
            '${port}',
          },
        },
      }
    end
    if not dap.adapters['node'] then
      dap.adapters['node'] = function(cb, config)
        if config.type == 'node' then
          config.type = 'pwa-node'
        end
        local nativeAdapter = dap.adapters['pwa-node']
        if type(nativeAdapter) == 'function' then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end

    local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

    local vscode = require 'dap.ext.vscode'
    vscode.type_to_filetypes['node'] = js_filetypes
    vscode.type_to_filetypes['pwa-node'] = js_filetypes

    for _, language in ipairs(js_filetypes) do
      if not dap.configurations[language] then
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end
    end

    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = 'Debug (Attach) - Remote',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }
  end,
  keys = {
    { '<F5>', '<cmd>lua require("dap").continue()<cr>', desc = 'Start/Continue' },
    { '<F1>', '<cmd>lua require("dap").step_into()<cr>', desc = 'Step Into' },
    { '<F2>', '<cmd>lua require("dap").step_over()<cr>', desc = 'Step Over' },
    { '<F3>', '<cmd>lua require("dap").step_out()<cr>', desc = 'Step Out' },
    { '<F7>', '<cmd>lua require("dapui").toggle()<cr>', desc = 'Toggle debug UI (see last session)' },
    { '<leader>dc', '<cmd>lua require("dap").continue()<cr>', desc = 'Start/Continue' },
    { '<leader>di', '<cmd>lua require("dap").step_into()<cr>', desc = 'Step Into' },
    { '<leader>do', '<cmd>lua require("dap").step_over()<cr>', desc = 'Step Over' },
    { '<leader>dO', '<cmd>lua require("dap").step_out()<cr>', desc = 'Step Out' },
    { '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = 'Toggle Breakpoint' },
    { '<leader>dB', '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', desc = 'Set Breakpoint' },
    { '<leader>dB', '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', desc = 'Set Breakpoint' },
    -- { '<leader>du', '<cmd>lua require("dapui").toggle()<cr>', desc = 'Toggle debug UI (see last session)' },
    { '<leader>du', '<cmd>lua require("dap-view").toggle()<cr>', desc = 'Toggle debug UI (see last session)' },
    {
      '<leader>td',
      function()
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = 'Debug Nearest',
    },
  },
}
