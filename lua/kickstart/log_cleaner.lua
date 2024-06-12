local M = {}

M.clean_copilot_log = function()
  local fidget = require 'fidget'

  local context_manager = require 'plenary.context_manager'
  local with = context_manager.with
  local open = context_manager.open

  local lsp_log = vim.lsp.get_log_path()
  local temp_lsp_log = lsp_log .. '.tmp'

  local telemetry_lines = 0
  local total_lines = 0

  local writer_result = with(open(temp_lsp_log, 'w'), function(writer)
    local reader_result = with(open(lsp_log, 'r'), function(reader)
      for line in reader:lines() do
        if not string.find(line, 'telemetry') then
          writer:write(line .. '\n')
        else
          telemetry_lines = telemetry_lines + 1
        end
      end
      return telemetry_lines
    end)
    return reader_result
  end)

  if writer_result == nil then
    fidget.notify('Error cleaning log', vim.log.levels.ERROR)
    return
  end

  fidget.notify(
    'Deleted ' .. telemetry_lines .. ' telemetry lines from ' .. total_lines .. ' total lines',
    vim.log.levels.INFO
  )

  local success, error_message = os.remove(lsp_log)
  if not success then
    print('Error removing lsp log: ' .. error_message)
  end

  success, error_message = os.rename(temp_lsp_log, lsp_log)
  if not success then
    print('Error renaming temp log: ' .. error_message)
  end

  success, error_message = os.remove(temp_lsp_log)
  if not success then
    print('Error removing temp log: ' .. error_message)
  end
end

return M
