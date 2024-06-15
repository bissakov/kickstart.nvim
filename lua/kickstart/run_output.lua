local M = {}

M.opts = {
  idx = 0,
  bufnr = nil,
}

M.jobstart = function(cmd, opts)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      if data then
        -- data = vim.fn.substitute(data, '\r\n', '\n', 'g')
        vim.api.nvim_buf_set_lines(opts.bufnr, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data, _)
      if data then
        -- data = vim.fn.substitute(data, '\r\n', '\n', 'g')
        -- data = vim.split(data, '\n')
        -- print('stderr:', data)
        vim.api.nvim_buf_set_lines(opts.bufnr, -1, -1, false, data)
      end
    end,
  })
end

M.run = function(opts)
  local file_name = vim.fn.expand '%:t'

  if opts.bufnr == nil then
    vim.cmd 'vsplit'
    opts.bufnr = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_win_set_width(0, 100)
  vim.api.nvim_win_set_buf(0, opts.bufnr)

  vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, { 'output of `' .. file_name .. '`:' })

  M.jobstart(
    { 'gcc', 'D:/Work/server_c/src/main.cpp', '-o', 'D:/Work/server_c/main.exe' },
    opts
  )

  M.jobstart({ 'D:/Work/server_c/main.exe' }, opts)
end

M.run(M.opts)
