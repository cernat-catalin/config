--[[
--  Limit of lua API and how to interact with vimscript:
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
-- XXX: Migrate vimwiki scripts from vimscript to lua
-- XXX: Avoid LSP in comments!
-- XXX: Standardize tab indent size
-- XXX: LSP and Git keymaps

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

  -- Installs LSP Servers
  -- XXX Replace with 'williamboman/nvim-lsp-installer'
  use 'williamboman/nvim-lsp-installer'

  -- Java LSP. Although installed via nvim-lspinstall
  -- We bring still package in scope for other things (e.g. require('jdtls.dap'))
  use 'mfussenegger/nvim-jdtls'

  -- LSP Java debug and main entry point runs
  use 'mfussenegger/nvim-dap'

  use 'gruvbox-community/gruvbox'

  -- Clojure XXX
  use 'Olical/conjure'
  use 'Olical/aniseed'


  -- Git support
  use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('gitsigns').setup()
  end
}
end)


-- Source Other Files
require('_common_settings')
require('_which-key')
require('_lsp')

-- Setup Git plugin
--require('gitsigns').setup()


-- Tree Sitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}


-- MacOS workaround: Bind Cmd+/ in the terminal to "<leader>ct"
if vim.fn.has('macunix') then
    vim.api.nvim_set_keymap('', '<leader>ct', '<plug>NERDCommenterToggle', {})
else
    vim.api.nvim_set_keymap('', '<C-_>', '<plug>NERDCommenterToggle', {})
end


require('gitsigns').setup {
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
    map('v', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
    map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
    map('v', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    --map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
    map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    --map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text objec
    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
