return {
  'stevearc/conform.nvim',
  lazy = false,
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
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    format_after_save = {
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = {
        'isort',
        'ruff_format',
      },
      go = { 'gofmt', 'goimports' },
      c = { 'clang-format' },
    },
  },
}
