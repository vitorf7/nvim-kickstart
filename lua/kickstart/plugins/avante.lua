return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  enabled = true,
  version = false, -- set this if you want to always pull the latest change
  build = 'make',
  opts = {
    debug = true,
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
  },

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    'ravitemer/mcphub.nvim',
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
    require('avante').setup(opts)
  end,
}
