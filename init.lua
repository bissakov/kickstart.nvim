--  NOTE: Logging

vim.lsp.set_log_level = 'DEBUG'

--  NOTE: Globals

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

--  NOTE: Options

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.showmode = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.timeoutlen = 50
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- vim.opt.listchars = { tab = '▹ ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.smartindent = true
vim.opt.iskeyword:append { '-' }

require('kickstart.py_env').setup()
require 'kickstart.mappings'

--  NOTE: Keymaps

vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without yanking' })
vim.keymap.set('v', 'x', '"_x', { desc = 'Delete character without yanking' })

vim.keymap.set('n', 's', '"_s', { desc = 'Replace character without yanking' })
vim.keymap.set('v', 's', '"_s', { desc = 'Replace character without yanking' })

vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

vim.keymap.set('n', '<M-x>', '"_dd', { desc = 'Cut the current line without yanking' })
vim.keymap.set('v', '<M-x>', '"_dd', { desc = 'Cut the current line without yanking' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', 'gb', '<c-o>', { desc = '[G]o [B]ack' })
vim.keymap.set('i', '<F1>', function() end, { desc = 'Disable documentation' })
vim.api.nvim_create_user_command('Q', 'q', {})

vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

vim.keymap.set('n', '\\', function()
  if vim.bo.filetype ~= 'oil' then
    vim.cmd 'Oil'
  end
end, { desc = 'Oil reveal' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-d>', 'yyp', { desc = 'Duplicate current line [D]own' })
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all [A]' })

vim.keymap.set('v', '<leader>gz', function()
  require('kickstart.plugins.web_search').web_seach 'google'
end, { desc = '[Z] [G]oogle Search' })

--  NOTE: Autocommands

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function add_include_guard()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if #lines == 1 and lines[1] == '' then
    local file_path = vim.fn.expand '%:p'
    local file_name = vim.fn.expand('%:t:r'):upper()
    local dir_name = vim.fn.fnamemodify(file_path, ':h:t'):upper()

    local guard_format = string.format('%s_%s_H_', dir_name, file_name)
    local guard = string.format(
      '#ifndef %s\n#define %s\n\n#endif  // %s',
      guard_format,
      guard_format,
      guard_format
    )

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(guard, '\n'))
  end
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.cpp', '*.h', '*.hpp' },
  callback = function()
    vim.bo.commentstring = '// %s'
    vim.keymap.set(
      'n',
      '<F1>',
      ':ClangdSwitchSourceHeader<cr>',
      { desc = 'ClangdSwitchSourceHeader' }
    )
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.h', '*.hpp' },
  callback = function()
    add_include_guard()
  end,
})

--  NOTE: Lazy setup

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  require 'kickstart.plugins.plugins',
}
