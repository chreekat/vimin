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

    let itemMarker = '- '

    let l = getline('.')

    let hasMarker = l =~ '^\s*' . itemMarker
    let atItemBegin = hasMarker && charcol('.') <= matchend(l, '^\s*' . itemMarker)
    let emptyLine = charcol('$') == 1
    let atLineEnd = ! emptyLine && charcol('.') + 1 >= charcol('$')
    let indentedMarker = hasMarker && l =~ '^\s'
    let emptyItem = l =~ '^\s*' . itemMarker . '$'

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
        call feedkeys('o' . itemMarker . "\<c-d>")
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

function! vimin#foldtext(start = v:foldstart, end = v:foldend) abort
    let level_marker = repeat(' ', &shiftwidth * v:foldlevel)
    let item_count = 0
    let curline = a:start
    while curline <= a:end
        if 0 == match(getline(curline), level_marker . '\S')
            let item_count += 1
        endif
        let curline += 1
    endwhile
    let item_word = item_count == 1 ? 'item' : 'items'
    let line_count = a:end - a:start + 1
    let line_word = line_count == 1 ? 'line' : 'lines'
    return
        \ printf("%s+- %d %s (%d %s) folded",
            \ level_marker, item_count, item_word, line_count, line_word)
endfunction
