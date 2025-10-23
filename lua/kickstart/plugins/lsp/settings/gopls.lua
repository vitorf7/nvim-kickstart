local lspconfig = require 'lspconfig'
return {
  on_attach = require('util').lsp.on_attach(function(client, bufnr)
    if client.name == 'gopls' then
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end
  end),
  -- capabilities = opts.capabilities,
  settings = {
    -- https://go.googlesource.com/vscode-go/+/HEAD/docs/settings.md#settings-for
    gopls = {
      experimentalPostfixCompletions = true,
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        fieldalignment = true,
      },
      expandWorkspaceToModule = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
      semanticTokens = true,
    },
  },
  -- override root_path for issue: https://github.com/golang/go/issues/63536
  root_path = function(fname)
    local root_files = {
      'tools/go.mod', -- monorepo override so root_path is ./monorepo/go/** not ./monorepo/**
      'go.work',
      'go.mod',
      '.git',
      '.golangci.yaml',
      '.golangci.yml',
      'flake.nix',
      'flake.lock',
    }

    -- return first parent dir that homes a found root_file
    return lspconfig.util.root_pattern(unpack(root_files))(fname) or vim.fs.dirname(fname)
  end,
}
