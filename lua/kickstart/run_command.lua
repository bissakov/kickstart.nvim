local M = {}

M.opts = {
  source = nil,
  executable = nil,
  file_ext = nil,
  width = 75,
}

local bufnr = 0

M.cmd = {
  cpp = {
    compile = function(source, executable)
      return { 'g++', source, '-o', executable }
    end,
    run = function(executable)
      return { executable }
    end,
  },
  python = {
    compile = function(_)
      return nil
    end,
    run = function(source)
      return { 'python', source }
    end,
  },
}

M.comment_style = {
  cpp = '// %s',
  lua = '-- %s',
  python = '# %s',
}

--- @param data table: The data to process.
local function process_lines(data)
  if data then
    for _, line in ipairs(data) do
      if line ~= '' then
        line = string.gsub(line, '\r', '')
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { line })
      end
    end
  end
end

--- Run a command and display the output in a new buffer.
--- @param cmd table?: The command to run.
--- @return nil
M.jobstart = function(cmd)
  if cmd == nil then
    return
  end

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      process_lines(data)
    end,
    on_stderr = function(_, data, _)
      process_lines(data)
    end,
  })
end

M.run = function(opts)
  opts = vim.tbl_extend('force', M.opts, opts)

  local buffers = vim.api.nvim_list_bufs()
  for _, buffer in ipairs(buffers) do
    local first_line = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]
    if string.match(first_line, '%=%=%=') ~= nil then
      print(buffer)
      break
    end
  end

  local current_time = os.date '%Y-%m-%d %H:%M:%S'

  local file_name = vim.fn.expand '%:t'
  -- local file_ext = vim.fn.expand '%:e'

  local comment = M.comment_style[opts.file_ext]
  local cmd = M.cmd[opts.file_ext]

  if bufnr == 0 then
    vim.cmd 'vsplit'
    bufnr = vim.api.nvim_create_buf(false, true)
    print('bufnr:', bufnr)
    vim.bo[bufnr].filetype = 'log'
  end
  vim.api.nvim_win_set_width(0, 75)
  vim.api.nvim_win_set_buf(0, bufnr)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    '==============================',
    current_time .. ' output of `' .. file_name .. '`:',
  })

  M.jobstart(cmd.compile(opts.source, opts.executable))
  M.jobstart(cmd.run(opts.executable))
end

M.run {
  source = 'D:/Work/server_c/src/main.cpp',
  executable = 'D:/Work/server_c/main.exe',
  file_ext = 'cpp',
}

-- M.run {
--   executable = 'D:/Work/test2024/test.py',
--   file_ext = 'python',
-- }
