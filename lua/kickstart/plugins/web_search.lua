--- @class WebSearch
local M = {}

--- Get the current selection in the buffer
--- @return string|nil, string|nil: Returns the selection text or nil, error message or nil
M.get_selection = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local range_start = vim.api.nvim_buf_get_mark(0, '<')
  local range_end = vim.api.nvim_buf_get_mark(0, '>')

  if range_start[1] == 0 or range_end[1] == 0 then
    return nil, 'No text is selected'
  end

  local selection_lines =
    vim.api.nvim_buf_get_lines(bufnr, range_start[1] - 1, range_end[1], false)
  if #selection_lines == 0 then
    return nil, 'Empty selection'
  else
    selection_lines[#selection_lines] =
      string.sub(selection_lines[#selection_lines], 1, range_end[2])
  end

  local selection_text =
    table.concat(selection_lines, ' '):gsub('\n', ' '):gsub('%s+', ' '):match '^%s*(.-)%s*$'
  return selection_text
end

---  Convert a character to its hexadecimal representation
---  @param c string
---  @return string
local char_to_hex = function(c)
  return string.format('%%%02X', string.byte(c))
end

---  URL encode a string
---  @param url string
---  @return string
local url_encode = function(url)
  url = url:gsub('\n', '\r\n')
  url = url:gsub('([^%w ])', char_to_hex)
  url = url:gsub(' ', '+')
  return url
end

--- Search the web for the current selection
--- @param service string
--- @return nil
M.web_seach = function(service)
  local fidget = require 'fidget'

  local search_engines = {
    google = 'https://www.google.com/search?q=',
    duckduckgo = 'https://duckduckgo.com/?q=',
    bing = 'https://www.bing.com/search?q=',
  }

  local url = search_engines[service]
  if not url then
    fidget.notify('Unknown search engine: ' .. service, vim.log.levels.ERROR)
    return
  end

  local selection, err = M.get_selection()
  if not selection then
    fidget.notify(err, vim.log.levels.ERROR)
    return
  end

  fidget.notify('Searching for: ' .. selection, vim.log.levels.INFO)

  local encoded_selection = url_encode(selection)
  local final_url = url .. encoded_selection
  fidget.notify('Opening: ' .. final_url, vim.log.levels.INFO)
  print('Searching ' .. service .. ' for:', selection)

  local open_cmd
  if vim.fn.has 'mac' == 1 then
    open_cmd = 'open '
  elseif vim.fn.has 'unix' == 1 then
    open_cmd = 'xdg-open '
  elseif vim.fn.has 'win32' == 1 then
    open_cmd = 'start '
  else
    fidget.notify('Unsupported OS', vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart(open_cmd .. final_url, { detach = true })
end

return M
