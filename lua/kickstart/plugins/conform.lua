return {
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
      go = { 'gofmt', 'goimports' },
      cmake = { 'cmake_format' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
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

    --  NOTE: C formatters
    conform.formatters.clang_format = {
      args = function(_, _)
        return {
          '-style',
          'google',
        }
      end,
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        conform.format { bufnr = args.buf }
      end,
    })
  end,
}
