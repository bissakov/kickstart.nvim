vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Format on save',
  pattern = { '*.py', '*.lua', '*.json' },
  group = vim.api.nvim_create_augroup('custom-auto-format', { clear = true }),
  callback = function()
    local mason_registry = require 'mason-registry'
    local current_file = vim.fn.expand '%:p'

    local file_ext = vim.fn.expand '%:e'

    if file_ext == 'py' then
      local isort = mason_registry.get_package('isort'):get_install_path()
      local ruff = mason_registry.get_package('ruff'):get_install_path()

      local isort_exe = isort .. '\\venv\\Scripts\\isort.exe'
      local ruff_exe = ruff .. '\\venv\\Scripts\\ruff.exe'

      local args = {
        '--line-length 80',
      }

      vim.cmd('silent !' .. isort_exe .. ' ' .. current_file)
      vim.cmd(
        'silent !'
          .. ruff_exe
          .. ' format '
          .. current_file
          .. ' '
          .. table.concat(args, ' ')
      )
    elseif file_ext == 'lua' then
      local stylua = mason_registry.get_package('stylua'):get_install_path()
      local stylua_exe = stylua .. '\\stylua.exe'

      local args = {
        '--indent-width 2',
        '--indent-type Spaces',
        '--column-width 90',
        '--quote-style AutoPreferSingle',
        '--call-parentheses None',
        '--sort-requires',
        '--line-endings Unix',
      }

      vim.cmd(
        'silent !' .. stylua_exe .. ' ' .. current_file .. ' ' .. table.concat(args, ' ')
      )
    elseif file_ext == 'json' then
      local jq_exe = mason_registry.get_package('jq'):get_install_path()
        .. '\\jq-windows-amd64.exe'
      vim.cmd(
        'silent !' .. jq_exe .. ' . ' .. current_file .. ' > ' .. current_file .. '.tmp'
      )
    end
  end,
})
