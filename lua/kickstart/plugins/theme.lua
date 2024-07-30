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

      local time = os.date '*t'
      if time.hour < 8 or time.hour > 19 then
        vim.cmd.colorscheme 'kanagawa-dragon'
      else
        vim.cmd.colorscheme 'kanagawa-wave'
      end

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
