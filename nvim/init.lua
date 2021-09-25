local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

opt.clipboard = "unnamedplus"

vim.api.nvim_set_keymap('', '<D-c>', '\"+y', {})



-- PACKER
-- TODO: Standardize style
-- TODO: Configure Telescope
-- TODO: Add old plugins
-- TODO: Add comments to all plugins
-- TODO: Migrate vimwiki scripts from vimscript to lua

require('packer').startup(function()
  use 'wbthomason/packer.nvim'              -- Package Management

  use 'nvim-treesitter/nvim-treesitter'     -- Syntax Parsing
  use 'neovim/nvim-lspconfig'               -- ??
  use 'projekt0n/github-nvim-theme'         -- Theme
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- old plugins
  use 'scrooloose/nerdcommenter'            -- ??
  use 'scrooloose/nerdtree'                 -- ??
  use 'vim-airline/vim-airline'             -- ??
  use 'vim-airline/vim-airline-themes'      -- ??

  use {
      'lervag/vimtex',
      ft = {'tex'}
  }
  use {
      'xuhdev/vim-latex-live-preview',
      ft = {'tex'}
  }
  use 'liuchengxu/vim-which-key'            -- Key suggestions when pressing leader
end)


vim.g.mapleader=" "
require('_settings')
require('_which-key')


-- Tree Sitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}
-- :TSInstall javascript

-- Theme
require('github-theme').setup({
  colors = {bg = "#212121"}
})


-- Other Settings --
-- MacOS workaround: Bind Cmd+/ in iTerm to " c " (asuming leader key is " "; see NERDCommenter default toggle shortcut)
vim.api.nvim_set_keymap('n', '<C-_>', '<plug>NERDCommenterToggle', {})
