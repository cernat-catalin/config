" Trigger which-key on leader key press
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" Timeout between leader key press and menu pop-up
set timeoutlen=10

" Don't use a floating window
let g:which_key_use_floating_win = 0

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \ | autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Color changes
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function


" Mappings
let g:which_key_map = {}

let g:which_key_map['w'] = {
            \ 'name' : '+wiki' ,
            \ 'w' : 'Wiki Index',
            \ 't' : 'Wiki Index - new tab',
            \ 's' : 'List and select wiki',
            \ 'd' : 'Delete wiki page',
            \ 'r' : 'Rename wiki page',
            \ 'n' : [':ZettelNew', 'New Zettel note'],
            \ 'i' : 'which_key_ignore',
            \ 'h' : 'which_key_ignore',
            \ 'hh' : 'which_key_ignore',
            \ ' ' : { 'name': 'which_key_ignore' }
            \ }


let g:which_key_map['s'] = {
            \ 'name' : '+search' ,
            \ 'f' : [':Files', 'File search'],
            "\ 'F' : ['', 'File search insert'],
            \ 'c' : [':ZettelOpen', 'Content search'],
            \ 'C' : [':ZettelSearch', 'Content Search insert'],
            \ }


" Register which key map
call which_key#register('<Space>', "g:which_key_map")

