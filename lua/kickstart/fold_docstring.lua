local M = {}

vim.api.nvim_create_namespace 'docstring_fold_ns'
function _G.DocstringFoldExpr(lnum)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local in_docstring = false
  local fold_levels = {}

  for i, line in ipairs(lines) do
    if in_docstring then
      fold_levels[i] = 1
      if line:find '"""' then
        in_docstring = false
      end
    else
      fold_levels[i] = 0
      if line:find '^%s*"""' then
        in_docstring = true
        fold_levels[i] = 1
      end
    end
  end

  return fold_levels[lnum] or 0
end

function M.docstring_fold()
  local current_file_type = vim.bo.filetype
  if current_file_type ~= 'python' then
    return
  end

  local foldmethod = vim.opt_local.foldmethod
  local foldexpr = vim.opt_local.foldexpr
  local foldenable = vim.opt_local.foldenable

  if foldmethod == 'expr' and foldexpr == 'v:lua.DocstringFoldExpr(v:lnum)' and foldenable then
    return
  end

  vim.opt_local.foldmethod = 'expr'
  vim.opt_local.foldexpr = 'v:lua.DocstringFoldExpr(v:lnum)'
  vim.opt_local.foldenable = true
end

return M
