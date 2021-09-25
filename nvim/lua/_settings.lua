local opt = vim.opt
local g   = vim.g

--filetype plugin indent on -- Enable filetype detection
vim.g.mapleader = ' '

opt.tabstop     = 4
opt.shiftwidth  = 4
opt.softtabstop = 4
opt.expandtab   = true
--set guicursor= -- Fix weird Konsole bug https://github.com/neovim/neovim/issues/6403
opt.list        = true -- Display trailing whitespace
opt.number      = true -- Enable line numbering
opt.clipboard   = "unnamed"
opt.ignorecase  = true -- Ignore case when searching (/). I think it also affects substitutions


