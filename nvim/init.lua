--[[
--  Limits of lua API and how to interact with vimscript:
--      1. `vim.cmd` is used for ... XXX
--      2. `vim.fn` is used for ... XXX
--      3. `vim.g` is used for ... XXX
--      4. `vim.opt` is used for ... XXX
--  Config files:
--      1. `init.lua` root config file. Manages plugins and sources other plugins.
--         Usually I test new settings here so it might contain other stuff.
--      2. `lua/_common_settings.lua` Contains simple options.
--      3. `lua/_which-key.lua` vim-which-key configurations.
--      4. `lua/_lsp.lua` LSP configurations.
--]]



-- XXX: Standardize style
-- XXX: Configure Telescope
-- XXX: Add old plugins
-- XXX: Add comments to all plugins
-- XXX: Migrate vimwiki scripts from vimscript to lua
-- XXX: Indent properly this file
-- XXX: Avoid LSP in comments!

require('packer').startup(function()
  -- Package Management
  use 'wbthomason/packer.nvim'

  -- Syntax Parsing
  use 'nvim-treesitter/nvim-treesitter'

  -- Common configurations for NVIMs LSP
  use 'neovim/nvim-lspconfig'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- Comment toggling
  use 'scrooloose/nerdcommenter'

  -- File Tree
  use 'scrooloose/nerdtree'

  -- XXX Not exactly sure if I need this
  use 'vim-airline/vim-airline'

  -- XXX Not exactly sure if I need this
  use 'vim-airline/vim-airline-themes'

  -- Tex support
  use {
      'lervag/vimtex',
      ft = {'tex'}
  }
  use {
      'xuhdev/vim-latex-live-preview',
      ft = {'tex'}
  }

  -- Key suggestions when pressing leader
  use 'liuchengxu/vim-which-key'

  -- LSP Completion helper
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  -- Ligature support for LSP completions
  -- XXX Alacritty doesn't have ligature support. Decide if to keep this.
  use 'onsails/lspkind-nvim'

  -- Installs LSP Servers
  -- XXX Replace with 'williamboman/nvim-lsp-installer'
  use 'kabouzeid/nvim-lspinstall'

  use 'gruvbox-community/gruvbox'
end)


-- Source Other Files
require('_common_settings')
require('_which-key')
require('_lsp')


-- Tree Sitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}
-- :TSInstall javascript


-- MacOS workaround: Bind Cmd+/ in the terminal to "<leader>ct"
if vim.fn.has('macunix') then
    vim.api.nvim_set_keymap('', '<leader>ct', '<plug>NERDCommenterToggle', {})
else
    vim.api.nvim_set_keymap('', '<C-_>', '<plug>NERDCommenterToggle', {})
end

