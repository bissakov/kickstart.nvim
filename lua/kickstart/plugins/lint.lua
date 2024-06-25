return {
  'dense-analysis/ale',
  config = function()
    local g = vim.g
    g.ale_ruby_rubocop_auto_correct_all = 1
    g.ale_linters = {
      cpp = { 'cpplint' },
      lua = { 'selene' },
    }
  end,
}
