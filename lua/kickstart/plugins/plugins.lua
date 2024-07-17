local supported_langs = require 'kickstart.supported_langs'

return {
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

  require 'kickstart.plugins.telescope',
  require 'kickstart.plugins.theme',
  require 'kickstart.plugins.lsp',
  require 'kickstart.plugins.conform',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.oil',
  require 'overseer.overseer',

  {
    'johmsalas/text-case.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    opts = {
      default_keymappings_enabled = false,
      enabled_methods = {
        'to_upper_case',
        'to_lower_case',
        'to_snake_case',
      },
    },
    config = function()
      local textcase = require 'textcase'
      textcase.setup {}
      require('telescope').load_extension 'textcase'

      vim.keymap.set('n', '<F9>', function()
        textcase.current_word 'to_snake_case'
      end)

      vim.keymap.set('n', '<S-F9>', function()
        textcase.lsp_rename 'to_snake_case'
      end)
    end,
    keys = {},
    cmd = {
      'Subs',
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
    lazy = false,
  },
  {
    'bissakov/copilot-telemetry-log-clean.nvim',
    event = 'VimLeavePre',
    enabled = true,
    dependencies = {
      'j-hui/fidget.nvim',
      'nvim-lua/plenary.nvim',
    },
    opts = {
      timeout = 500,
    },
    config = function(_, opts)
      local copilot_log_clean = require 'copilot-telemetry-log-clean'
      copilot_log_clean.setup(opts)
    end,
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

  require 'kickstart.plugins.treesitter',
  require 'kickstart.plugins.debug',

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
  {
    'github/copilot.vim',
    ft = supported_langs,
    config = function()
      vim.cmd 'Copilot disable'
    end,
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
}
