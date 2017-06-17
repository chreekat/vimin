" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
    " | Won't be reached, unless ^ is commented out (for reloading during testing)
    iunmap <buffer> <cr>
    iunmap <script> <Plug>ViminNewItem
endif
let b:did_ftplugin = 1

setlocal comments=fb\:——,\:>
setlocal foldmethod=indent
setlocal formatoptions=tcqnl1jo
setlocal ignorecase
setlocal shiftwidth=4
setlocal smartcase

iabbrev <buffer> -- ——

" Begin a new item, or move the newly-begun item around. Bound to <cr> in insert
" mode.
" Situations:
"    no marker,
"    empty item,
"    cursor at beginning/in marker,
"    item indented,
"    item not indented
" Outcomes (order not related to situations above):
"    De-indent current line,
"    start new item,
"    split current item,
"    break item's line,
"    move line down
function! s:new_item()
    let remapSave = &remap

    let l = getline('.')

    let hasMarker = l =~ '^\s*—— '
    let atItemBegin = hasMarker && col('.') <= matchend(l, '^\s*—— ')
    let emptyLine = col('$') == 1
    let atLineEnd = ! emptyLine && col('.') + 1 >= col('$')
    let indentedMarker = hasMarker && l =~ '^\s'
    let emptyItem = l =~ '^\s*—— $'

    if (atItemBegin || emptyItem)
        " Operate on the item as a whole
        if indentedMarker
            normal <<3l
        else " Nonindented
            " Move down
            normal O
            normal j3l
        endif
        if emptyItem
            startinsert!
        else
            startinsert
        endif
    elseif emptyLine
        " Just add a line
        normal o
        startinsert!
    elseif atLineEnd
        " Start a new item
        exec "normal o——\<space>\<c-d>"
        startinsert!
    else " Either no marker or in the middle of an item
        set noremap
        if hasMarker
            " Wrap current item's text. This is different form the following
            " branch because of vim's autoformatting.
            exec "normal a\<cr>   "
        else
            " Newline as normal. FIXME: It's not "as normal" because of
            " autoindent magic.
            exec "normal a\<cr> \<c-h>"
        endif
        let &remap = remapSave
        if getline('.') =~ '^\s*$'
            normal l
        endif
        call feedkeys('a','n')
    endif
endfunction

imap <unique> <buffer> <cr> <Plug>ViminNewItem
inoremap <unique> <script> <Plug>ViminNewItem <SID>NewItem
inoremap <SID>NewItem <esc>:call <SID>new_item()<cr>
