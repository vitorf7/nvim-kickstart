return {
  'yetone/avante.nvim',
  lazy = true,
  enabled = true,
  version = false, -- set this if you want to always pull the latest change
  build = 'make',
  opts = {},

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      event = 'BufEnter',
      enabled = false,
    },
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = true,
          prompt_for_file_name = true,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = false,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },

  config = function(_, opts)
    require('avante_lib').load()
    require('avante').setup {
      debug = false,
      -- cursor_applying_provider = nil,
      behaviour = {
        enable_cursor_planning_mode = true,
        enable_claude_text_editor_tool_mode = true,
      },

      provider = 'copilot',
      providers = {
        copilot = { model = 'claude-3.5-sonnet' },
        ollama = {
          endpoint = 'http://127.0.0.1:11434', -- Note that there is no /v1 at the end.
          model = 'qwen2.5-coder:7b', -- Specify your model here
          stream = true,
        },
      },
      windows = {
        postion = 'right',
        width = 40,
        sidebar_header = {
          enabled = true,
          align = 'center',
          rounded = true,
        },
        input = {
          prefix = ' ',
          height = 12, -- Height of the input window in vertical layout
        },
      },
      file_selector = {
        provider = 'snacks',
      },
      selector = {
        provider = 'snacks',
      },
      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub:get_active_servers_prompt()
      end,

      custom_tools = function()
        return {
          require('mcphub.extensions.avante').mcp_tool(),
        }
      end,
    }
  end,
}
