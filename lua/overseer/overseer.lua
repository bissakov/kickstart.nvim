return {
  'stevearc/overseer.nvim',
  opts = {
    task_list = {
      direction = 'right',
    },
  },
  config = function()
    require('overseer').setup {
      templates = { 'builtin', 'user.run_script' },
    }
  end,
}
