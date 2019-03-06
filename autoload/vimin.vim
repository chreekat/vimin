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
function! vimin#new_item()
    let remapSave = &remap

    let l = getline('.')

    let hasMarker = l =~ '^\s*- '
    let atItemBegin = hasMarker && col('.') <= matchend(l, '^\s*- ')
    let emptyLine = col('$') == 1
    let atLineEnd = ! emptyLine && col('.') + 1 >= col('$')
    let indentedMarker = hasMarker && l =~ '^\s'
    let emptyItem = l =~ '^\s*- $'

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
        call feedkeys('o')
    elseif atLineEnd
        " Start a new item
        call feedkeys("o-\<space>\<space>\<c-d>")
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
        call feedkeys('a')
    endif
endfunction
