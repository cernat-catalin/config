-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Indent settings
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.expandtab   = true


-- Display trailing whitespace
vim.opt.list = true

-- Enable line numbering
vim.opt.number         = true
vim.opt.relativenumber = true


-- XXX ??
vim.opt.clipboard = "unnamedplus"

-- Ignore case when searching (/). I think it also affects substitutions.
vim.opt.ignorecase  = true

-- Fix weird Konsole bug https://github.com/neovim/neovim/issues/6403
--set guicursor=

-- Colorscheme
vim.opt.termguicolors = true
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_contrast_light = "hard"
vim.cmd('colorscheme gruvbox')


-- Autopairs
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))


-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
require('nvim-autopairs').setup{}
