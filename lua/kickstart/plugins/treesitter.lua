local supported_langs = require 'kickstart.supported_langs'

--- Get the languages that are supported by treesitter
--- @param langs string[]
--- @return string[]
local function get_supported_languages(langs)
  local parsers = require 'nvim-treesitter.parsers'
  local supported = {}

  for _, lang in ipairs(langs) do
    if parsers.get_parser_configs()[lang] then
      table.insert(supported, lang)
    end
  end

  return supported
end

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  ft = {
    'bash',
    'c',
    'cpp',
    'cmake',
    'diff',
    'go',
    'html',
    'json',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'python',
    'query',
    'vim',
    'vimdoc',
    'yaml',
    'yml',
  },
  opts = {
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
    opts.ensure_installed = get_supported_languages(supported_langs)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
