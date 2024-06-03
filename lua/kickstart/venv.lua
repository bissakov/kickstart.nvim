local M = {}

function M.setup()
  local utils = require 'kickstart.utils'
  local vimrc = os.getenv 'MYVIMRC' or vim.fn.stdpath 'config' .. '/init.lua'
  local config_path = vim.fn.fnamemodify(vimrc, ':h')
  local venv = config_path .. '/venv'
  local is_win32 = vim.fn.has 'win32' == 1
  local bin_path = utils.ternary(is_win32, venv .. '/Scripts', venv .. '/bin')
  local pip = utils.ternary(is_win32, bin_path .. '/pip.exe', venv .. '/pip')

  if not vim.fn.isdirectory(venv) then
    vim.cmd('!py -3.11 -m venv ' .. venv)
    vim.cmd('!' .. pip .. ' install neovim')
  end

  vim.g.python3_host_prog =
    utils.ternary(is_win32, bin_path .. '/python.exe', bin_path .. '/python')
end

return M
