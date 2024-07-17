return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    opts = {
      dimInactive = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
    },
    init = function()
      require('kanagawa').setup()

      vim.cmd.colorscheme 'kanagawa-dragon'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    init = function()
      -- require('vscode').setup()

      -- vim.cmd.colorscheme 'vscode'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
}
