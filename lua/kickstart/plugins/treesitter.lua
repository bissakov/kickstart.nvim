local ensure_installed = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'python',
  'query',
  'vim',
  'vimdoc',
}

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  ft = ensure_installed,
  opts = {
    ensure_installed = ensure_installed,
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
