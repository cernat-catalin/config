filetype plugin on " Enable filetype detection
let mapleader=" " " Set mapleader key
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set guicursor= " Fix weird Konsole bug https://github.com/neovim/neovim/issues/6403
set list " Display trailing whitespace
set number " Enable line numbering
set clipboard+=unnamedplus " Clipboard support


" Turn spellcheck on for markdown files
augroup auto_spellcheck
  autocmd BufNewFile,BufRead *.md,*.tex setlocal spell
augroup END
