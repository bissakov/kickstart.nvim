return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map(
            'gI',
            require('telescope.builtin').lsp_implementations,
            '[G]oto [I]mplementation'
          )
          map(
            '<leader>D',
            require('telescope.builtin').lsp_type_definitions,
            'Type [D]efinition'
          )
          map(
            '<leader>ds',
            require('telescope.builtin').lsp_document_symbols,
            '[D]ocument [S]ymbols'
          )
          map(
            '<leader>ws',
            require('telescope.builtin').lsp_dynamic_workspace_symbols,
            '[W]orkspace [S]ymbols'
          )
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
          then
            local highlight_augroup =
              vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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
              callback = function(event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                  group = 'kickstart-lsp-highlight',
                  buffer = event.buf,
                }
              end,
            })
          end

          if
            client
            and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
          then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
              )
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      --  NOTE:  LSP Servers
      local servers = {

        --  NOTE: Golang Plugins
        gopls = {
          filetypes = { 'go', 'gomod' },
          settings = {
            gopls = {
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        golangci_lint_ls = {},

        --  NOTE: Python Plugins
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                typeCheckingMode = 'basic',
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },

        --  NOTE: Lua Plugins
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = {
                  'vim',
                  'require',
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },

        --  NOTE: C/C++ Plugins
        clangd = {
          cmd = {
            'clangd',
            '--offset-encoding=utf-16',
            '--clang-tidy',
            '--completion-style=bundled',
            '--cross-file-rename',
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
        },
        neocmake = {
          cmd = { 'neocmakelsp', '--stdio' },
          filetypes = { 'cmake' },
          single_file_support = true,
          settings = {
            neocmake = {
              init_options = {
                format = {
                  enable = true,
                },
                lint = {
                  enable = true,
                },
                scan_cmake_in_package = true,
              },
            },
          },
        },

        --  NOTE: Zig plugins
        zls = {},

        --  NOTE: JSON Plugins
        jq = {},

        --  NOTE: JavaScript Plugins
        angularls = {
          cmd = { 'ngserver' },
          filetypes = {
            'ts',
            'typescript',
            'html',
          },
          settings = {
            angularls = {
              args = {
                '--stdio',
                '--tsProbeLocations',
                '/usr/local/lib/node_modules/typescript/lib',
                '--ngProbeLocations',
                '/usr/local/lib/node_modules/@angular/language-server/bin',
              },
              trace = {
                server = {
                  verbosity = 'verbose',
                },
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'isort',
        'ruff',
        'prettierd',
      })
      local excluded_servers = { 'ruff' }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            if vim.tbl_contains(excluded_servers, server_name) then
              return
            end

            local server = servers[server_name] or {}
            server.capabilities =
              vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            if server_name == 'ruff_lsp' then
              server.capabilities.hoverProvider = false
            end

            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
