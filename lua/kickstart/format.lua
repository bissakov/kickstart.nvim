local conform = require 'conform'

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
conform.formatters.ruff_format = {
  prepend_args = { '--line-length 80' },
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
