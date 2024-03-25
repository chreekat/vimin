let s:itemMarker = '- '
let s:noteMarker = '> '

" When backspacing through the item marker, the backspace through the rest of
" the line as well, ending up on the end of the previous line.
function! vimin#backspace()
    let l = getline('.')
    if match(l, '^\s*' .. s:itemMarker .. '\s*$') == 0
        " There's an implicit 'k' if we're on the last line.
        if line('.') == line('$')
            normal dd
        else
            normal ddk
        endif
        startinsert!
    else
        if charcol('.') == charcol('$') - 1
            normal x
            startinsert!
        else
            normal x
            startinsert
        endif
    endif
endfunction

" Begin a new item above the current one.
" Situations:
"     no marker,
"     marker
function! vimin#new_item_above()
    let l = getline('.')
    let hasMarker = l =~ '^\s*' . s:itemMarker

    if hasMarker
        call feedkeys('O' . s:itemMarker, 'n')
    else
        " Pass-through
        call feedkeys('O', 'n')
    endif
endfunction

" Begin a new item, or move the newly-begun item around. Bound to <cr> in insert
" mode.
" Situations:
"    no marker,
"    empty item,
"    cursor at beginning/in marker,
"    item indented,
"    item not indented,
"    blank line,
"    in a note
" Outcomes (order not related to situations above):
"    De-indent current line,
"    start new item,
"    split current item,
"    break item's line,
"    move line down,
"    continue note,
"    split line within a note
function! vimin#new_item()
    let l = getline('.')

    let hasMarker = l =~ '^\s*' . s:itemMarker
    let inNote = l =~ '^\s*' . s:noteMarker
    let atItemBegin = hasMarker && charcol('.') <= matchend(l, '^\s*' . s:itemMarker)
    let emptyLine = charcol('$') == 1
    let blankLine = l =~ '^\s*$'
    let atLineStart = charcol('.') == 1
    let atLineEnd = ! emptyLine && charcol('.') + 1 >= charcol('$')
    let indentedMarker = hasMarker && l =~ '^\s'
    let emptyItem = l =~ '^\s*' . s:itemMarker . '$'

    if atItemBegin || emptyItem
        " Operate on the item as a whole
        if indentedMarker
            normal <<3l
        else " Nonindented
            " Move down
            normal! O
            normal j3l
        endif
        if emptyItem
            startinsert!
        else
            startinsert
        endif
    elseif emptyLine
        " Just add a line
        call feedkeys('o', 'n')
    elseif blankLine
        " Replace current line with blank item. Indent taken automatically from
        " level of spaces in the line.
        call feedkeys("a" .. s:itemMarker .. "\<cr>")
    elseif atLineEnd && ! inNote
        " Start a new item
        call feedkeys('o' . s:itemMarker . "\<c-d>", 'n')
    elseif inNote
        call feedkeys("a\<cr>> ", 'n')
    else " Either no marker or in the middle of an item
        " Middle of item
        if hasMarker
            " Wrap current item's text. This is different form the following
            " branch because of vim's autoformatting.
            exec "normal! a\<cr>  "
        else
            if atLineStart
                exec "normal! i\<cr>"
            else " No marker and not at line start
                exec "normal! a\<cr>"
            endif
            " Deal with weird formatting if not at beginning of line, I think?
            if charcol('.') != 1
                normal l
            endif
        endif
        call feedkeys('i', 'n')
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
