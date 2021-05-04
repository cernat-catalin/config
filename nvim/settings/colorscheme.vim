" 24-bit color support
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

syntax on " Enable syntax highlighting
colorscheme pencil

let g:airline_theme='bubblegum'
