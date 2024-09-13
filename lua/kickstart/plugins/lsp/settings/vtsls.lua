return {
  -- explicitly add default filetypes, so that we can extend
  -- them in related extras
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  on_attach = function(client, bufnr)
    if client.name == 'vtsls' then
      client.commands['_typescript.moveToFileRefactoring'] = function(command, ctx)
        ---@type string, string, lsp.Range
        local action, uri, range = unpack(command.arguments)

        local function move(newf)
          client.request('workspace/executeCommand', {
            command = command.command,
            arguments = { action, uri, range, newf },
          })
        end

        local fname = vim.uri_to_fname(uri)
        client.request('workspace/executeCommand', {
          command = 'typescript.tsserverRequest',
          arguments = {
            'getMoveToRefactoringFileSuggestions',
            {
              file = fname,
              startLine = range.start.line + 1,
              startOffset = range.start.character + 1,
              endLine = range['end'].line + 1,
              endOffset = range['end'].character + 1,
            },
          },
        }, function(_, result)
          ---@type string[]
          local files = result.body.files
          table.insert(files, 1, 'Enter new path...')
          vim.ui.select(files, {
            prompt = 'Select move destination:',
            format_item = function(f)
              return vim.fn.fnamemodify(f, ':~:.')
            end,
          }, function(f)
            if f and f:find '^Enter new path' then
              vim.ui.input({
                prompt = 'Enter move destination:',
                default = vim.fn.fnamemodify(fname, ':h') .. '/',
                completion = 'file',
              }, function(newf)
                return newf and move(newf)
              end)
            elseif f then
              move(f)
            end
          end)
        end)
      end

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      map('gD', function()
        local params = vim.lsp.util.make_position_params()
        require('util').lsp.execute {
          command = 'typescript.goToSourceDefinition',
          arguments = { params.textDocument.uri, params.position },
          open = true,
        }
      end, 'Goto Source Definition')
      map('gR', function()
        require('util').lsp.execute {
          command = 'typescript.findAllFileReferences',
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        }
      end, 'File References')
      map('<leader>co', require('util').lsp.action['source.organizeImports'], 'Organize Imports')
      map('<leader>cM', require('util').lsp.action['source.addMissingImports.ts'], 'Add missing imports')
      map('<leader>cu', require('util').lsp.action['source.removeUnused.ts'], 'Remove unused imports')
      map('<leader>cD', require('util').lsp.action['source.fixAll.ts'], 'Fix all diagnostics')
      map('<leader>cV', function()
        require('util').lsp.execute { command = 'typescript.selectTypeScriptVersion' }
      end, 'Select TS workspace version')
    end
  end,
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  -- keys = {
  --   {
  --     'gD',
  --     function()
  --       local params = vim.lsp.util.make_position_params()
  --       require('util').lsp.execute {
  --         command = 'typescript.goToSourceDefinition',
  --         arguments = { params.textDocument.uri, params.position },
  --         open = true,
  --       }
  --     end,
  --     desc = 'Goto Source Definition',
  --   },
  --   {
  --     'gR',
  --     function()
  --       require('util').lsp.execute {
  --         command = 'typescript.findAllFileReferences',
  --         arguments = { vim.uri_from_bufnr(0) },
  --         open = true,
  --       }
  --     end,
  --     desc = 'File References',
  --   },
  --   {
  --     '<leader>co',
  --     require('util').lsp.action['source.organizeImports'],
  --     desc = 'Organize Imports',
  --   },
  --   {
  --     '<leader>cM',
  --     require('util').lsp.action['source.addMissingImports.ts'],
  --     desc = 'Add missing imports',
  --   },
  --   {
  --     '<leader>cu',
  --     require('util').lsp.action['source.removeUnused.ts'],
  --     desc = 'Remove unused imports',
  --   },
  --   {
  --     '<leader>cD',
  --     require('util').lsp.action['source.fixAll.ts'],
  --     desc = 'Fix all diagnostics',
  --   },
  --   {
  --     '<leader>cV',
  --     function()
  --       require('util').lsp.execute { command = 'typescript.selectTypeScriptVersion' }
  --     end,
  --     desc = 'Select TS workspace version',
  --   },
  -- },
}
