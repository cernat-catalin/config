" 24-bit color support
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

hi Comment cterm=italic
let g:nvcode_hide_endofbuffer=1
let g:nvcode_terminal_italics=1
let g:nvcode_termcolors=256

syntax on " Enable syntax highlighting
colorscheme nvcode
