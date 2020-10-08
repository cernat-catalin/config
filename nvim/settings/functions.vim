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
                \ "filename": expand('%:t'),
                \ "extension": expand('%:e'),
                \ "line":  line('.'),
                \ "column": col('.')
                \ }
endfunction

function! s:insert_search(line)
    let result_location = s:search_result_location(a:line)
    let state = s:current_state()
    let c_line = state['line']
    let c_col = state['column']
    let line = getline('.')

    call setline('.', strpart(line, 0, c_col))
endfunction

" Check if a file does not exist in the wiki
function! s:wiki_file_not_exists(filename)
    let link_info = vimwiki#base#resolve_link(a:filename)
    return empty(glob(link_info.filename)) 
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


" ===== Command Functions =====

function! s:custom_open_file_search()
    call fzf#vim#files('.',
                \ fzf#vim#with_preview({'sink': function('s:open_file_file_search')}))
endfunction

function! s:custom_open_content_search()
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case .', 1,
                \ fzf#vim#with_preview({'sink': function('s:open_file_content_search'), 'options': '--delimiter : --nth 4..'}))
endfunction


" TODO: Not working at all
function! s:custom_insert_content_search()
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case .', 1,
                \ fzf#vim#with_preview({'sink': function('s:insert_search'), 'options': '--delimiter : --nth 4..'}))
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
command! -bang CustomInsertContentSearch call s:custom_insert_content_search()
command! -bang CustomOpenFileSearch call s:custom_open_file_search()
command! -bang CustomNewZettel call s:custom_new_zettel()
command! -bang CustomNewDaily call s:custom_new_daily()
