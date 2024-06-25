--  NOTE: Logging

vim.lsp.set_log_level = 'DEBUG'

--  NOTE: Globals

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

--  NOTE: Options

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'
vim.opt.showmode = true
vim.opt.clipboard = 'unnamedplus'
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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.smartindent = true
vim.opt.iskeyword:append { '-' }

require('kickstart.py_env').setup()
require 'kickstart.mappings'

--  NOTE: Keymaps

vim.opt.hlsearch = true
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without yanking' })
vim.keymap.set('n', '<M-x>', '"_dd', { desc = 'Cut the current line without yanking' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

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

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.cpp',
  callback = function()
    vim.bo.commentstring = '// %s'
  end,
})

--  NOTE: Lazy setup

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  require 'kickstart.plugins.plugins',
}
