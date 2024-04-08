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

    " Line content
    let hasMarker = l =~ '^\s*' . s:itemMarker
    let inNote = l =~ '^\s*' . s:noteMarker
    let emptyLine = charcol('$') == 1
    let blankLine = l =~ '^\s*$'
    let indentedMarker = hasMarker && l =~ '^\s'
    let emptyItem = l =~ '^\s*' . s:itemMarker . '\s*$'

    " Cursor location
    let atItemBegin = hasMarker && charcol('.') <= matchend(l, '^\s*' . s:itemMarker)
    let atLineStart = charcol('.') == 1
    let atLineEnd = ! emptyLine && charcol('.') + 1 >= charcol('$')

    " hasMarker -> NOT blankLine
    " hasMarker -> NOT emptyLine
    "
    " emptyItem -> hasMarker
    "
    " indentedMarker -> hasMarker
    "
    " emptyLine -> atLineEnd
    " emptyLine -> atLineStart
    "
    " atLineEnd && atLineStart -> emptyLine
    "
    if emptyLine
        " Just add a line
        call feedkeys('o', 'n')
    elseif blankLine
        " Replace current line with blank item. Indent taken automatically from
        " level of spaces in the line.
        call feedkeys("a" .. s:itemMarker .. "\<cr>")
    elseif inNote
        call feedkeys("a\<cr>> ", 'n')
    elseif atItemBegin
        if emptyItem
            if indentedMarker
                " De-indent current line
                normal! <<2l
                startinsert!
            else
                " Start a new item. TODO: Maybe create blank lines instead?
                call feedkeys("\<cr>" . s:itemMarker, 'n')
                startinsert!
            endif
        else
            " Insert new blank above
            normal O
            startinsert!
        endif
    elseif atLineEnd && ! inNote
        " Start a new item
        call feedkeys('o' . s:itemMarker . "\<c-d>", 'n')
    else " Not blank, not empty, not in note, either no marker or in the middle of an item
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

" Return [i,j] where i is the first line of the item and j is the last line
" (including children).
function! vimin#item_limit() abort
    let l = line('.')
    let item_level = indent(l) / &shiftwidth
    let i = l
    while match(getline(i), '^\s*' . s:itemMarker) == -1
        let i -= 1
    endwhile
    let j = l
    while j < line('$') && ( indent(j+1) / &shiftwidth > item_level )
        let j += 1
    endwhile
    return [i, j]
endfunction

" A command to use in an operator-pending mapping that operates on the current
" item.
" Example: >ai will indent the entire item.
function! vimin#operate_item() abort
    let [i, j] = vimin#item_limit()
    exec string(i)
    exec 'normal V' . string(j) . 'G'
endfunction
