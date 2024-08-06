return {
  'dense-analysis/ale',
  config = function()
    local g = vim.g
    g.ale_ruby_rubocop_auto_correct_all = 1
    g.ale_linters = {
      cmake = { 'cmake_lint' },
      c = { 'cpplint' },
      cpp = { 'cpplint', 'clangtidy' },
      lua = { 'selene' },
      python = { 'ruff' },
      zig = { 'zls' },
    }

    g.ale_cpp_clangtidy_extra_options = '-std=c++17 -W4 -Wunused-variable -I. -Isrc -Iinclude'
  end,
}
