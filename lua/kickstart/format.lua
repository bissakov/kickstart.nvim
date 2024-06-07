local is_windows = vim.fn.has 'win32' == 1
utils = require 'kickstart.utils'

local formatters = {
  py = {
    cmd = function(mason_registry, current_file)
      local isort = mason_registry.get_package('isort'):get_install_path()
      local ruff = mason_registry.get_package('ruff'):get_install_path()

      local bin_path = is_windows and '/Scripts' or '/bin'
      local isort_exe = utils.join({ isort, 'venv', bin_path, 'isort' }, '/')
      local ruff_exe = utils.join({ ruff, 'venv', bin_path, 'ruff' }, '/')

      local args = utils.join({ '--line-length 80' }, ' ')

      local cmd = utils.join(
        { isort_exe, current_file, '&&', ruff_exe, 'format', current_file, args },
        ' '
      )
      return cmd
    end,
  },
  lua = {
    cmd = function(mason_registry, current_file)
      local stylua = mason_registry.get_package('stylua'):get_install_path()
      local stylua_exe = stylua .. (is_windows and '/stylua.exe' or '/stylua')

      local args = utils.join({
        '--indent-width 2',
        '--indent-type Spaces',
        '--column-width 95',
        '--quote-style AutoPreferSingle',
        '--call-parentheses None',
        '--sort-requires',
        '--line-endings Unix',
      }, ' ')

      local cmd = utils.join({ stylua_exe, current_file, args }, ' ')
      return cmd
    end,
  },
  c = {
    cmd = function(mason_registry, current_file)
      local clang_format = mason_registry.get_package('clang-format'):get_install_path()
      local bin_path =
        utils.join({ clang_format, 'venv', is_windows and 'Scripts' or 'bin' }, '/')
      local clang_format_exe =
        utils.join({ bin_path, is_windows and 'clang-format.exe' or 'clang-format' }, '/')

      local args = utils.join({ '-style=google' }, ' ')
      local cmd = utils.join({ clang_format_exe, args, '-i', current_file }, ' ')
      return cmd
    end,
  },
  json = {
    cmd = function(mason_registry, current_file)
      local jq = mason_registry.get_package 'jq'
      local jq_exe = jq:get_install_path() .. '/jq-windows-amd64.exe'
      local cmd = utils.join({ jq_exe, '.', current_file, '>', current_file, '.tmp' }, ' ')
      return cmd
    end,
  },
}

vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Format on save',
  pattern = { '*.py', '*.lua', '*.c', '*.json' },
  group = vim.api.nvim_create_augroup('custom-auto-format', { clear = true }),
  callback = function()
    local mason_registry = require 'mason-registry'
    local current_file = vim.fn.expand '%:p'

    local file_ext = vim.fn.expand '%:e'
    local formatter = formatters[file_ext]
    if formatter == nil then
      return
    end

    local cmd = formatter.cmd(mason_registry, current_file)
    vim.cmd('silent !' .. cmd)
  end,
})
