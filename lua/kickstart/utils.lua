local M = {}

--- Ternary operator
--- @param cond boolean
--- @param T any
--- @param F any
--- @return any
function M.ternary(cond, T, F)
  if cond then
    return T
  else
    return F
  end
end

--- Join a list of strings with a separator
--- @param args table
--- @param sep string
--- @return string
function M.join(args, sep)
  return table.concat(args, sep)
end

--- Set a timeout
--- @param timeout number
--- @return table
function M.setTimeout(timeout)
  local timer = vim.uv.new_timer()
  timer:start(timeout, 0, function()
    timer:stop()
    timer:close()
  end)
  return timer
end

return M
