return {
  {
    'hrsh7th/nvim-cmp',
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '*',
    -- build = 'cargo build --release',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').load { paths = { './my_snippets' } }
          end,
        },
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      {
        'saghen/blink.compat',
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = '*',
      },
      'moyiz/blink-emoji.nvim',
    },
    opts = function(_, opts)
      local icons = require('util').icons.kinds
      local appearance = opts.appearance or {}
      local optsIcons = vim.tbl_extend('force', appearance.kind_icons or {}, icons)

      local luasnip = require 'luasnip'

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      local myopts = {
        signature = { enabled = true },

        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = false,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
          kind_icons = optsIcons,
        },

        completion = {
          accept = {
            -- experimental auto-brackets support
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            draw = {
              columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
              treesitter = { 'lsp' },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
        },
        snippets = {
          expand = function(snippet)
            require('luasnip').lsp_expand(snippet)
          end,
          active = function(filter)
            if filter and filter.direction then
              return require('luasnip').jumpable(filter.direction)
            end
            return require('luasnip').in_snippet()
          end,
          jump = function(direction)
            require('luasnip').jump(direction)
          end,
        },
        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          -- adding any nvim-cmp sources here will enable them
          -- with blink.compat
          default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'emoji' },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
            emoji = {
              module = 'blink-emoji',
              name = 'Emoji',
              score_offset = 15, -- Tune by preference
              opts = { insert = true }, -- Insert emoji (default) or complete its name
            },
          },
        },
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
        keymap = {
          preset = 'default',
          ['<C-y>'] = { 'select_and_accept' },

          -- Select the [n]ext item
          ['<C-n>'] = { 'select_next', 'fallback' },
          -- Select the [p]revious item
          ['<C-p>'] = { 'select_prev', 'fallback' },
          -- Select the [n]ext item
          ['<C-j>'] = { 'select_next', 'fallback' },
          -- Select the [p]revious item
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<C-l>'] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            'snippet_forward',
            'fallback',
          },
          ['<C-h>'] = { 'snippet_backward', 'fallback' },
        },
      }

      opts = vim.tbl_extend('force', opts, myopts)

      return opts
    end,
    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.default',
    },
  },
}
