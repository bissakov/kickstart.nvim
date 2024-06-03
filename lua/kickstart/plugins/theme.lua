return {
  'Mofiqul/vscode.nvim',
  priority = 1000,
  init = function()
    require('vscode').setup()

    vim.cmd.colorscheme 'vscode'
    vim.cmd.hi 'Comment gui=none'
  end,
}
