return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- {
    --   'nvim-java/nvim-java',
    -- },
  },
  config = function(_, opts)
    -- Brief Aside: **What is LSP?**
    --
    -- LSP is an acronym you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gd', function()
          Snacks.picker.lsp_definitions()
        end, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gr', function()
          Snacks.picker.lsp_references()
        end, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.

        map('gi', function()
          Snacks.picker.lsp_implementations()
        end, '[G]oto [I]mplementation')

        -- Flot diagnostic under the cursor
        map('gl', vim.diagnostic.open_float, '[G]oto [L]ine diagnostic')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        -- map('<leader>lD', require('telescope.builtin').lsp_type_definitions, '[L]SP Type [D]efinition')
        map('<leader>lD', function()
          Snacks.picker.lsp_type_definitions()
        end, '[L]SP Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        -- map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[L]SP: Document [S]ymbols')
        map('<leader>ls', function()
          Snacks.picker.lsp_symbols()
        end, '[L]SP: Document [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace
        --  Similar to document symbols, except searches over your whole project.
        -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>ws', function()
          Snacks.picker.lsp_workspace_symbols()
        end, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        if client and client.server_capabilities.documentFormattingProvider then
          map('<leader>lf', vim.lsp.buf.format, '[L]SP: [F]ormat')
        end

        if client and client.server_capabilities.codeLensProvider then
          -- Displays the codelens for the current line
          --  See `:help vim.lsp.codelens`
          map('<leader>lc', vim.lsp.codelens.run, '[L]SP: Run [C]ode Lens')
          map('<leader>lC', vim.lsp.codelens.run, '[L]SP: Refresh & Display [C]ode Lens')
        end

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Refresh the codelens for the current line
        --  See `:help vim.lsp.codelens`
        if client and client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh { bufnr = event.buf }
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      -- ts_ls = {},
      --
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = require('util').mason_tools
    vim.list_extend(ensure_installed, require('util').servers)

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      automatic_installation = true,
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          if server_name == 'bufls' then
            server_name = 'buf_ls'
          end

          local server = {}
          local lsp_settings_ok, lsp_settings = pcall(require, 'kickstart.plugins.lsp.settings.' .. server_name)
          if lsp_settings_ok then
            server = vim.tbl_deep_extend('force', server, lsp_settings)
          end

          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          if server_name == 'ts_ls' then
            -- disable server
          elseif server_name == 'jdtls' then
            return true
            -- disable server
            -- elseif server_name == 'jdtls' then
            --   -- Start nvim-java before lspconfig
            --   require('java').setup {
            --     root_markers = {
            --       'settings.gradle',
            --       'settings.gradle.kts',
            --       'pom.xml',
            --       'build.gradle',
            --       'mvnw',
            --       'gradlew',
            --       'build.gradle',
            --       'build.gradle.kts',
            --     },
            --     java_debug_adapter = {
            --       enable = false,
            --     },
            --     jdk = {
            --       auto_install = false,
            --     },
            --   }
            --   require('lspconfig').jdtls.setup(require 'kickstart.plugins.lsp.settings.jdtls')
          else
            require('lspconfig')[server_name].setup(server)
          end
        end,
      },
    }
  end,
}
