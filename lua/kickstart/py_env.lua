local M = {}

function M.setup()
  local venv = vim.fn.stdpath 'config' .. '/venv'

  local bin_path, pip, py
  if vim.fn.has 'win32' == 1 then
    bin_path = venv .. '/Scripts'
    pip = bin_path .. '/pip.exe'
    py = bin_path .. '/python.exe'
  else
    bin_path = venv .. '/bin'
    pip = venv .. '/pip'
    py = bin_path .. '/python'
  end

  if not vim.fn.isdirectory(venv) then
    vim.cmd('!py -3.11 -m venv ' .. venv)
    vim.cmd('!' .. pip .. ' install neovim')
  end

  vim.g.python3_host_prog = py
end

return M
