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
  use 'altercation/vim-colors-solarized'    -- Theme
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
--require('github-theme').setup({
  --colors = {bg = "#212121"}
--})
vim.cmd("colorscheme solarized")

-- line numbering
opt.relativenumber = true


-- Other Settings --

-- MacOS workaround: Bind Cmd+/ in iTerm to "<leader>ct"
if vim.fn.has('macunix') then
    vim.api.nvim_set_keymap('', '<leader>ct', '<plug>NERDCommenterToggle', {})
else
    vim.api.nvim_set_keymap('', '<C-_>', '<plug>NERDCommenterToggle', {})
end




-- LSP

local nvim_lsp = require('lspconfig')

require'lspconfig'.pyright.setup{}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
