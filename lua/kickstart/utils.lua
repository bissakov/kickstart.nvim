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

--- Merge two tables
--- @param t1 table
--- @param t2 table
--- @return table
function M.merge(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

return M
