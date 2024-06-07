local is_windows = vim.fn.has 'win32' == 1

local formatters = {
  py = {
    cmd = function(mason_registry, current_file)
      local isort = mason_registry.get_package('isort'):get_install_path()
      local ruff = mason_registry.get_package('ruff'):get_install_path()

      local bin_path = is_windows and '/Scripts' or '/bin'
      local isort_exe = isort .. '/venv' .. bin_path .. '/isort.exe'
      local ruff_exe = ruff .. '/venv' .. bin_path .. '/ruff.exe'

      local args = {
        '--line-length 80',
      }

      local isort_cmd = isort_exe .. ' ' .. current_file
      local ruff_cmd = ruff_exe .. ' format ' .. current_file .. ' ' .. table.concat(args, ' ')
      local cmd = isort_cmd .. ' && ' .. ruff_cmd

      return cmd
    end,
  },
  lua = {
    cmd = function(mason_registry, current_file)
      local stylua = mason_registry.get_package('stylua'):get_install_path()
      local stylua_exe = stylua .. (is_windows and '/stylua.exe' or '/stylua')

      local args = {
        '--indent-width 2',
        '--indent-type Spaces',
        '--column-width 95',
        '--quote-style AutoPreferSingle',
        '--call-parentheses None',
        '--sort-requires',
        '--line-endings Unix',
      }

      local cmd = stylua_exe .. ' ' .. current_file .. ' ' .. table.concat(args, ' ')

      return cmd
    end,
  },
  c = {
    cmd = function(mason_registry, current_file)
      local clang_format = mason_registry.get_package('clang-format'):get_install_path()
      local bin_path = is_windows and '/Scripts' or '/bin'
      local clang_format_exe = clang_format
        .. '/venv'
        .. bin_path
        .. (is_windows and '/clang-format.exe' or '/clang-format')

      local args = {
        '-style=google',
      }
      local cmd = clang_format_exe .. ' ' .. table.concat(args, ' ') .. ' -i ' .. current_file

      return cmd
    end,
  },
  json = {
    cmd = function(mason_registry, current_file)
      local jq = mason_registry.get_package 'jq'
      local jq_exe = jq:get_install_path() .. '/jq-windows-amd64.exe'
      local cmd = jq_exe .. ' . ' .. current_file .. ' > ' .. current_file .. '.tmp'
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
