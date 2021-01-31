" ===== Wiki Functions =====


" ===== Helper Functions =====

" Return result location for fzf search
function! s:search_result_location(search_result)
    let tokens = split(a:search_result, ':')
    return {
                \ "relative_path": tokens[0],
                \ "line":  tokens[1],
                \ "column": tokens[2]
                \ }
endfunction

" Return current state of cursor
function! s:current_state()
    return {
                \ "path": expand('%:p'),
                \ "directory": expand('%:p:h'),
                \ "filename": expand('%:t'),
                \ "extension": expand('%:e'),
                \ "line":  line('.'),
                \ "column": col('.')
                \ }
endfunction

" Check if a file does not exist in the wiki
function! s:wiki_file_not_exists(filename)
    let link_info = vimwiki#base#resolve_link(a:filename)
    return empty(glob(link_info.filename)) 
endfunction

function! s:list_all_zettels()
    " Get current folder
    let state = s:current_state()

    " Create new file
    execute ':new scratch.md'
    setlocal buftype=nofile
    "setlocal filetype=vimwiki

    " Search for all zettel files with title
    let text = system("rg --multiline -e '---\ntitle: ([^\n]+)+\n' " . state['directory'] . " -r '$1'")

    call setline(1, '# Zettel notes')
    call setline(2, '')
    let line = 3
    for x in split(text, '\n')
        let tokens = split(x, ':')
        let file = split(tokens[0], '/')[-1]
        let title = tokens[1]
        call setline(line, '* [' . title . '](' . file . ')')
        let line += 1
    endfor
endfunction


" ===== Callback Functions =====

" Open file using fzf content search result
function! s:open_file_content_search(search_result)
    let result_location = s:search_result_location(a:search_result)
    let state = s:current_state()

    " TODO: Target file must also be a .md file
    if state['extension'] == "md"
        call vimwiki#base#open_link(':e +' . result_location['line'], result_location['relative_path'])
    else
        execute ':e +' . result_location['line'] . " " . result_location['relative_path']
    endif

endfunction


" Open file using fzf file search result
function! s:open_file_file_search(search_result)
    let state = s:current_state()

    " TODO: Target file must also be a .md file
    if state['extension'] == "md"
        call vimwiki#base#open_link(':e ', a:search_result)
    else
        execute ':e ' . a:file_path
    endif
endfunction


function! s:insert_content_search_link(search_result)
    let result_location = s:search_result_location(a:search_result)
    let state = s:current_state()

    let wikiname = fnamemodify(result_location['relative_path'], ':r') 
    let c_line = state['line']
    let c_col = state['column']
    let line = getline('.')

    call setline('.', strpart(line, 0, c_col) . "[ref](" . wikiname . ")" . strpart(line, c_col))

    let c_pos = getpos('.')
    let c_pos[2] = c_pos[2] + 2
    call setpos('.', c_pos)

endfunction

" ===== Command Functions =====

function! s:custom_open_file_search()
    call fzf#vim#files('.',
                \ fzf#vim#with_preview({'sink': function('s:open_file_file_search')}))
endfunction

function! s:custom_open_content_search()
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case .', 2,
                \ fzf#vim#with_preview({'sink': function('s:open_file_content_search'), 'options': '--exact --delimiter : --nth 4..'}))
endfunction


" TODO: Not working at all
function! s:custom_insert_content_search_link()
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case .', 1,
                \ fzf#vim#with_preview({'sink': function('s:insert_content_search_link'), 'options': '--delimiter : --nth 4..'}))
endfunction



" Create a new custom zettle wiki entry
function! s:custom_new_zettel()
    let filename = strftime("%y%m%d-%H%M") . '.md'
    let wiki_not_exists = s:wiki_file_not_exists(filename)

    call vimwiki#base#open_link(':e ', filename)

    if wiki_not_exists
        let header_title = "title:"
        let header_date = "date: " . strftime("%Y-%m-%d %H:%M")

        call append(line("^"), "---")
        call append(line("^"), header_date)
        call append(line("^"), header_title)
        call append(line("^"), "---")
    endif
endfunction


" Create a new custom daily wiki entry
function! s:custom_new_daily()
    let filename = "daily_" . strftime("%y%m%d") . '.md'
    let wiki_not_exists = s:wiki_file_not_exists(filename)

    call vimwiki#base#open_link(':e ', filename)

    if wiki_not_exists
        let title = "# Daily " . strftime("%Y-%m-%d %H:%M")
        call append(line("^"), title)
    endif
endfunction



command! -bang CustomOpenContentSearch call s:custom_open_content_search()
command! -bang CustomInsertContentSearch call s:custom_insert_content_search_link()
command! -bang CustomOpenFileSearch call s:custom_open_file_search()
command! -bang CustomNewZettel call s:custom_new_zettel()
command! -bang CustomNewDaily call s:custom_new_daily()
command! -bang ListAllZettels call s:list_all_zettels()
