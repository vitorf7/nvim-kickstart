return { -- Autoformat
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = function(bufnr)
        local configArgs = { 'goimports', 'gofumpt' }
        local ctx = require('conform.runner').build_context(bufnr, configArgs)

        local telecomFixedLine = '(telecom%-fixed%-line)'

        local startIndexTelecom, _ = string.find(ctx.dirname, telecomFixedLine)

        if startIndexTelecom == nil then
          table.insert(configArgs, 'gci')
        end

        local goMonoPathSeach1 = '(go%-mono)/(teams)/(contact%-channels)'
        local goMonoPathSeach2 = '(go%-mono)/(teams)/(help%-and%-support)'

        local startIndex1, _ = string.find(ctx.dirname, goMonoPathSeach1)
        local startIndex2, _ = string.find(ctx.dirname, goMonoPathSeach2)

        -- Snacks.debug('startIndex1 startIndex2', startIndex1, startIndex2)
        local startIndex = startIndex1 or startIndex2
        -- Snacks.debug('startIndex', startIndex)
        -- Snacks.debug('ctx.dirname', ctx.dirname)

        if startIndex ~= nil then
          table.insert(configArgs, 'golines')
        end

        Snacks.debug('config', configArgs)
        return configArgs
      end,
      -- go = { 'goimports', 'gofumpt', 'gci' },
      toml = { 'taplo' },
      sql = { 'sql_formatter' },
      mysql = { 'sql_formatter' },
      proto = { 'buf' },
      terraform = { 'terraform_fmt' },
      tf = { 'terraform_fmt' },
      ['terraform-vars'] = { 'terraform_fmt' },
      -- local supported = {
      --   "css",
      --   "graphql",
      --   "handlebars",
      --   "html",
      --   "javascript",
      --   "javascriptreact",
      --   "json",
      --   "jsonc",
      --   "less",
      --   "markdown",
      --   "markdown.mdx",
      --   "scss",
      --   "typescript",
      --   "typescriptreact",
      --   "vue",
      --   "yaml",
      -- }
      graphql = { 'prettierd' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },

      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
    formatters = {
      gci = {
        command = 'gci',
        -- args = { 'write', '--skip-generated', '--skip-vendor', '-s', 'standard', '-s', 'default', '-s', 'prefix(github.com/utilitywarehouse)', '$FILENAME' },
        args = function(_, ctx)
          local args = { 'write', '--skip-generated', '--skip-vendor', '-s', 'standard', '-s', 'default' }
          local goMonoPathSeach = '(go)-(mono)'

          local startIndex, _ = string.find(ctx.dirname, goMonoPathSeach)

          -- Snacks.debug('startIndex', startIndex)
          -- Snacks.debug('ctx.dirname', ctx.dirname)

          if startIndex ~= nil then
            table.insert(args, '-s')
            table.insert(args, 'prefix(github.com/utilitywarehouse/go-mono)')
          else
            table.insert(args, '-s')
            table.insert(args, 'prefix(github.com/utilitywarehouse)')
          end

          table.insert(args, '$FILENAME')

          -- Snacks.debug('gci args', args)
          return args
        end,
      },
      golines = {
        args = { '--base-formatter=gofumpt', '--ignore-generated', '--max-len=140' },
      },
    },
  },
}
