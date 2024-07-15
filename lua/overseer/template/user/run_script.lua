return {
  name = 'run script',
  builder = function()
    local file = vim.fn.expand '%:p'
    local cmd = { file }

    local filetype = vim.bo.filetype

    if filetype == 'go' then
      cmd = { 'go', 'run', file }
    elseif filetype == 'python' then
      cmd = { 'python', file }
    end
    return {
      cmd = cmd,
      components = {
        { 'on_output_quickfix', set_diagnostics = true },
        'on_result_diagnostics',
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'sh', 'python', 'go' },
  },
}
