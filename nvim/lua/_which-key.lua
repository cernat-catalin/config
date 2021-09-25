local opt = vim.opt
local g = vim.g

-- Trigger which-key on leader key press
vim.api.nvim_set_keymap('n', '<leader>', ":WhichKey '<Space>'<CR>", {noremap = true, silent = true})

opt.timeoutlen = 10 -- Timeout between leader key press and menu pop-up
vim.g.which_key_use_floating_win = 0 -- Don't use a floating window


-- Hide status line
vim.cmd [[
    autocmd! FileType which_key
    autocmd  FileType which_key set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
]]

-- Color changes
vim.cmd [[
    highlight default link WhichKey          Operator
    highlight default link WhichKeySeperator DiffAdded
    highlight default link WhichKeyGroup     Identifier
    highlight default link WhichKeyDesc      Function
]]



-- Mappings
g.which_key_map = {}
g.which_key_map.w = {}

g.which_key_map = {
    w = {
        name = '+wiki',
        w    = 'Wiki Index',
        t    = 'Wiki Index - new tab',
        d    = 'Delete wiki page',
        r    = 'Rename wiki page',
        l    = {':ListAllZettels', 'List all zettels'},
        z    = {':CustomNewZettel', 'New zettel'},
        s    = {':OpenLastScratch', 'Open last scratch'},
        S    = {':NewScratch', 'New sratch'},
        hh   = 'which_key_ignore',
        i    = 'which_key_ignore',
        h    = 'which_key_ignore',
        n    = 'which_key_ignore'
        --' ' : { 'name': 'which_key_ignore' }
    },
    s = {
        name = '+search' ,
        f    = {':CustomOpenFileSearch', 'File search'},
        c    = {':CustomOpenContentSearch', 'Content search'},
        C    = {':CustomInsertContentSearch', 'Insert content search'}
    },
    m = {
        name = '+markdown' ,
        p    = {':MarkdownPreview', 'Markdown preview'},
        s    = {':set spell!', 'Toggle spellcheck'},
        h    = {':InsertDashes', 'Insert Dashes'}
    }
}

-- How to debug: print(vim.inspect(<variable_name>))
--print(vim.inspect(g.which_key_map))

-- Register which key map
vim.call('which_key#register', '<Space>', 'g:which_key_map')
