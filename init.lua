--  NOTE: Logging

vim.lsp.set_log_level = 'INFO'

--  NOTE: Globals

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

--  NOTE: Options

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.showmode = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.timeoutlen = 50
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.smartindent = true
vim.opt.iskeyword:append { '-' }

--  NOTE: Keymaps

vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without yanking' })
vim.keymap.set('v', 'x', '"_x', { desc = 'Delete character without yanking' })

vim.keymap.set('n', 's', '"_s', { desc = 'Replace character without yanking' })
vim.keymap.set('v', 's', '"_s', { desc = 'Replace character without yanking' })

vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

vim.keymap.set('n', '<M-x>', '"_dd', { desc = 'Cut the current line without yanking' })
vim.keymap.set('v', '<M-x>', '"_dd', { desc = 'Cut the current line without yanking' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', 'gb', '<c-o>', { desc = '[G]o [B]ack' })

vim.keymap.set('i', '<F1>', function() end, { desc = 'Disable documentation' })
vim.keymap.set('n', '<F1>', function() end, { desc = 'Disable documentation' })
vim.keymap.set('v', '<F1>', function() end, { desc = 'Disable documentation' })

vim.api.nvim_create_user_command('Q', 'q', {})

vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

vim.keymap.set('n', '\\', function()
  if vim.bo.filetype ~= 'oil' then
    vim.cmd 'Oil'
  end
end, { desc = 'Oil reveal' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-d>', 'yyp', { desc = 'Duplicate current line [D]own' })
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all [A]' })

vim.keymap.set('v', '<leader>gz', function()
  require('kickstart.plugins.web_search').web_seach 'google'
end, { desc = '[Z] [G]oogle Search' })

--  NOTE: Autocommands

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--  NOTE: Lazy setup

local supported_langs = {
  'bash',
  'c',
  'cpp',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'python',
  'query',
  'vim',
  'vimdoc',
  'yaml',
  'yml',
}

--- Get the languages that are supported by treesitter
--- @param langs string[]
--- @return string[]
local function get_supported_languages(langs)
  local parsers = require 'nvim-treesitter.parsers'
  local supported = {}

  for _, lang in ipairs(langs) do
    if parsers.get_parser_configs()[lang] then
      table.insert(supported, lang)
    end
  end

  return supported
end

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk' },
        { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
      }

      vim.api.nvim_create_user_command('W', 'w', {})
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            'node_modules',
            'venv',
            '.repro',
            '.git',
            '.cache',
            '.idea',
            'logs',
            'src_old',
            '%.exe',
            '%.pdb',
            '%.dll',
            '%.o',
            '%.obj',
            '%.tlog',
            '%.idb',
            '%.ilk',
            '%.suo',
            '%.user',
            '%.sdf',
            '%.opensdf',
            '%.sln',
            '%.vcxproj',
            '%.vcxproj.filters',
            '%.vcxproj.user',
            'LICENSE',
            '%.exe',
            '%.ppm',
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set(
        'n',
        '<leader>sf',
        ':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
        { desc = '[S]earch [F]iles' }
      )
      vim.keymap.set(
        'n',
        '<leader>ss',
        builtin.builtin,
        { desc = '[S]earch [S]elect Telescope' }
      )
      vim.keymap.set(
        'n',
        '<leader>sw',
        builtin.grep_string,
        { desc = '[S]earch current [W]ord' }
      )
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set(
        'n',
        '<leader>sd',
        builtin.diagnostics,
        { desc = '[S]earch [D]iagnostics' }
      )
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set(
        'n',
        '<leader>s.',
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
      )
      vim.keymap.set(
        'n',
        '<leader><leader>',
        builtin.buffers,
        { desc = '[ ] Find existing buffers' }
      )

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    {
      'rebelot/kanagawa.nvim',
      priority = 1000,
      opts = {
        dimInactive = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
      },
      init = function()
        require('kanagawa').setup()

        local time = os.date '*t'
        if time.hour < 8 or time.hour > 19 then
          vim.cmd.colorscheme 'kanagawa-dragon'
        else
          vim.cmd.colorscheme 'kanagawa-wave'
        end

        vim.cmd.hi 'Comment gui=none'
      end,
    },
    {
      'Mofiqul/vscode.nvim',
      priority = 1000,
      init = function()
        -- require('vscode').setup()

        -- vim.cmd.colorscheme 'vscode'
        -- vim.cmd.hi 'Comment gui=none'
      end,
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  {
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
              and client.supports_method(
                vim.lsp.protocol.Methods.textDocument_documentHighlight
              )
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
        }

        require('mason').setup()

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua',
          'isort',
          'ruff',
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
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format {
            async = true,
            lsp_fallback = true,
          }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      format_after_save = {
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = {
          'isort',
          'ruff_format',
        },
        json = { 'fixjson' },
      },
    },
    config = function(_, opts)
      local conform = require 'conform'
      conform.setup(opts)

      --  NOTE: Python formatters
      conform.formatters.isort = {
        args = function(_, _)
          return {
            '--stdout',
            '--filename',
            '$FILENAME',
            '-',
          }
        end,
      }

      -- HACK: This hack works (overriding args)
      conform.formatters.ruff_format = {
        args = {
          'format',
          '--line-length',
          '80',
          '--force-exclude',
          '--stdin-filename',
          '$FILENAME',
          '-',
        },
      }

      --  NOTE: Lua formatters
      conform.formatters.stylua = {
        prepend_args = {
          '--column-width',
          '95',
          '--line-endings',
          'Unix',
          '--indent-type',
          'Spaces',
          '--indent-width',
          '2',
          '--quote-style',
          'AutoPreferSingle',
          '--call-parentheses',
          'None',
        },
      }

      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function(args)
          conform.format { bufnr = args.buf }
        end,
      })
    end,
  },
  {
    'dense-analysis/ale',
    config = function()
      local g = vim.g
      g.ale_ruby_rubocop_auto_correct_all = 1
      g.ale_linters = {
        lua = { 'selene' },
        python = { 'ruff' },
      }
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = true,
      columns = {
        'icon',
      },
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        timeout_ms = 1000,
        autosave_changes = false,
      },
      constrain_cursor = 'editable',
      experimental_watch_for_changes = false,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select_split', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select_split', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select_split', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' } },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
      use_default_keymaps = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
      },
      extra_scp_args = {},
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        override = function(conf)
          return conf
        end,
      },
      preview = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        update_on_cursor_moved = true,
      },
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        minimized_border = 'none',
        win_options = {
          winblend = 0,
        },
      },
      ssh = {
        border = 'rounded',
      },
      keymaps_help = {
        border = 'rounded',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'Bilal2453/luvit-meta',
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0,
      })
    end,
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},

          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'folke/todo-comments.nvim',
    ft = supported_langs,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      highlight = {
        keyword = 'bg',
        pattern = [[.*<(KEYWORDS)\s*:*]],
      },
    },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    ft = {
      'bash',
      'c',
      'cpp',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'python',
      'query',
      'vim',
      'vimdoc',
      'yaml',
      'yml',
    },
    opts = {
      auto_install = true,
      incremental_selection = {
        enable = true,
      },
      fold = {
        enable = true,
      },
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      opts.ensure_installed = get_supported_languages(supported_langs)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    ft = supported_langs,
    main = 'ibl',
    config = function()
      require('ibl').setup {
        debounce = 100,
        indent = { char = '│', priority = 500 },
        whitespace = { highlight = { 'Whitespace', 'NonText' } },
        scope = { enabled = false },
      }
    end,
  },
  'tpope/vim-sleuth',
  {
    'lewis6991/gitsigns.nvim',
    ft = supported_langs,
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        map(
          'n',
          '<leader>tb',
          gitsigns.toggle_current_line_blame,
          { desc = '[T]oggle git show [b]lame line' }
        )
        map(
          'n',
          '<leader>tD',
          gitsigns.toggle_deleted,
          { desc = '[T]oggle git show [D]eleted' }
        )
      end,
    },
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    config = function()
      require('trouble').setup()
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {
        map_bs = false,
      }
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'mg979/vim-visual-multi',
    event = 'BufEnter',
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
