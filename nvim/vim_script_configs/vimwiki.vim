let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'path_html': '~/vimwiki_html/',
                      \ 'syntax': 'markdown',
                      \ 'custom_wiki2html': '~/.config/nvim/scripts/wiki2html2.sh',
                      \ 'template_path': '~/.config/nvim/scripts/',
                      \ 'template_default': 'template',
                      \ 'template_ext': '.html',
                      \ 'ext': '.md'}]

let g:vimwiki_key_mappings = { 'table_mappings': 0 }    " Don't steal TAB mapping
let g:vimwiki_autowriteall = 1 " auto save when changing buffer
