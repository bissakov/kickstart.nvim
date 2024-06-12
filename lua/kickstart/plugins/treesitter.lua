local supported_langs = require 'kickstart.supported_langs'

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  ft = supported_langs,
  opts = {
    ensure_installed = supported_langs,
    auto_install = true,
    incremental_selection = {
      enable = true,
    },
    fold = {
      enable = true,
    },
    highlight = {
      enable = true,
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end,
}
