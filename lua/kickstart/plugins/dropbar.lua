return {
  'Bekaboo/dropbar.nvim',
  config = function()
    local bar = require 'dropbar.bar'

    ---@class dropbar_source_t
    local mini_diff_stats = {
      get_symbols = function(buff, _, _)
        local summary = vim.b[buff].minidiff_summary

        if not summary then
          return {}
        end

        local stats = {}

        if not summary.add and not summary.change and not summary.delete and not summary.n_ranges then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = '󱀶 ',
              icon_hl = 'Untracked',
              name = '',
              name_hl = 'Untracked',
            }
          )
        end

        if summary.n_ranges and summary.n_ranges > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Modified',
              name = tostring(summary.n_ranges),
              name_hl = 'Modified',
            }
          )
        end

        if summary.delete and summary.delete > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Removed',
              name = tostring(summary.delete),
              name_hl = 'Removed',
            }
          )
        end

        if summary.change and summary.change > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Changed',
              name = tostring(summary.change),
              name_hl = 'Changed',
            }
          )
        end

        if summary.add and summary.add > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = ' ',
              icon_hl = 'Added',
              name = tostring(summary.add),
              name_hl = 'Added',
            }
          )
        end

        return stats
      end,
    }

    ---@class dropbar_source_t
    local lsp_diagnostics = {
      get_symbols = function(buff, _, _)
        local diagnosticIcons = require('util').icons.diagnostics

        local errors = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.ERROR })
        local warnings = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.WARN })
        local infos = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.INFO })
        local hints = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.HINT })

        local stats = {}

        if #errors > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = diagnosticIcons.error,
              icon_hl = 'DiagnosticError',
              name = tostring(#errors),
              name_hl = 'DiagnosticError',
            }
          )
        end

        if #warnings > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = diagnosticIcons.warn,
              icon_hl = 'DiagnosticWarn',
              name = tostring(#warnings),
              name_hl = 'DiagnosticWarn',
            }
          )
        end

        if #infos > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = diagnosticIcons.info,
              icon_hl = 'DiagnosticInfo',
              name = tostring(#infos),
              name_hl = 'DiagnosticInfo',
            }
          )
        end

        if #hints > 0 then
          table.insert(
            stats,
            bar.dropbar_symbol_t:new {
              icon = diagnosticIcons.hint,
              icon_hl = 'DiagnosticHint',
              name = tostring(#hints),
              name_hl = 'DiagnosticHint',
            }
          )
        end

        return stats
      end,
    }

    local dropbar_api = require 'dropbar.api'
    vim.keymap.set('n', '<Leader>Bp', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
    vim.keymap.set('n', '<Leader>Bc', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '<Leader>Bn', dropbar_api.select_next_context, { desc = 'Select next context' })

    ---@class dropbar_source_t
    require('dropbar').setup {
      icons = {
        enabled = true,
        ui = {
          bar = {
            separator = ' ',
            extends = '…',
          },
        },
      },
      bar = {
        sources = function(buf, _)
          local dropbarUtils = require 'dropbar.utils'
          local sources = require 'dropbar.sources'
          if vim.bo[buf].ft == 'markdown' then
            return {
              sources.path,
              sources.markdown,
              mini_diff_stats,
              lsp_diagnostics,
            }
          end
          if vim.bo[buf].buftype == 'terminal' then
            return {
              sources.terminal,
            }
          end
          return {
            sources.path,
            dropbarUtils.source.fallback {
              sources.lsp,
              sources.treesitter,
            },
            mini_diff_stats,
            lsp_diagnostics,
          }
        end,
      },
    }
  end,
}
