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
