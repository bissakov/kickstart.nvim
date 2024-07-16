return {
  'stevearc/overseer.nvim',
  opts = {
    task_list = {
      bindings = {
        ['?'] = false,
        ['g?'] = false,
        ['<CR>'] = false,
        ['<C-e>'] = false,
        ['o'] = false,
        ['<C-v>'] = false,
        ['<C-s>'] = false,
        ['<C-f>'] = false,
        ['<C-q>'] = false,
        ['p'] = false,
        ['<C-l>'] = false,
        ['<C-h>'] = false,
        ['L'] = false,
        ['H'] = false,
        ['['] = false,
        [']'] = false,
        ['{'] = false,
        ['}'] = false,
        ['<C-k>'] = false,
        ['<C-j>'] = false,
        ['q'] = false,
      },
    },
  },
  config = function()
    local overseer = require 'overseer'
    overseer.setup {
      templates = { 'builtin', 'user.run_script' },
    }

    local window = require 'overseer.window'

    vim.keymap.set('n', '<F12>', function()
      local winid = window.get_win_id()
      window.toggle { direction = 'right', winid = winid }
      overseer.run_template(
        {},
        ---@param task overseer.Task
        function(task)
          task:open_output 'horizontal'
        end
      )
    end, { desc = '' })
  end,
}
