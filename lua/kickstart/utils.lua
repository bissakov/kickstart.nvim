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

return M
