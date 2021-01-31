call plug#begin()
    " Colorscheme
    Plug 'christianchiarulli/nvcode.vim'
    " Bottom status bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Comment toggling
    Plug 'scrooloose/nerdcommenter'
    " File system explorer
    Plug 'scrooloose/nerdtree'
    " Real-time markdown preview
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
    " Latex support: compilation and preview
    Plug 'lervag/vimtex', { 'for': 'tex'}
    Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex'}
    " Vim wiki
    Plug 'vimwiki/vimwiki'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " Completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Key suggestions when pressing leader
    Plug 'liuchengxu/vim-which-key'

    " Copy images to markdown
    Plug 'ferrine/md-img-paste.vim'
call plug#end()


source $HOME/.config/nvim/settings/general.vim
source $HOME/.config/nvim/settings/colorscheme.vim
source $HOME/.config/nvim/settings/functions.vim
source $HOME/.config/nvim/plug-config/which-key.vim
source $HOME/.config/nvim/plug-config/vimwiki.vim
source $HOME/.config/nvim/plug-config/coc.vim


" ===== Other settings =====

" Remap comment toggling to Ctrl-/ ('_' is '/')
map <C-_> <plug>NERDCommenterToggle

" Remap NERDTree toggle
map <F2> :NERDTreeToggle<CR>

" Exit terminal mode with ESC
tmap <ESC> <C-\><C-n>

"let g:python3_host_prog = '~/miniconda3/bin/python'

let g:airline_theme='bubblegum'


autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
"

function! g:Open_browser(url)
    silent exec "!firefox -new-window " . a:url . " &"
endfunction

let g:mkdp_browserfunc = 'g:Open_browser'


