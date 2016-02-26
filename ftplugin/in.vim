" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Get the fold level for a line.
func! InboxFoldDepth(lineNr) abort
    " '=' is not recommended because it's slow, but most lines are one of
    " the "special cases" below, and performance seems pretty good.
    let depth = '='

    " Case: New item.
    if s:itemStartsOn(a:lineNr)
        let depth = s:nestLevel(a:lineNr)

        " Case: Starting a new nesting.
        if s:itemHasSubItems(a:lineNr, depth)
            let depth = '>' . (depth + 1)
        " Case: Bare item (no subitems) is multiline, or has notes. Treat
        " as zero-child new nesting.
        elseif nextnonblank(a:lineNr + 1) == a:lineNr + 1
               \ && s:nextItem(a:lineNr) > a:lineNr + 1
            let depth = '>' . (depth + 1)
        endif
    " Case: Empty line.
    elseif match(getline(a:lineNr), '\S') == -1
        " Empty lines belong to whatever around them is lower -- unless
        " whatever's lower is >1. In that case, we want 0 to avoid annoying
        " 1-line folds.
        if s:nextLevel(a:lineNr) == ">1"
            let depth = 0
        else
            let depth = -1
        endif
    endif

    return depth
endfunc

" Get the nest level for a line.
"
" Equivalent to (num leading spaces) / shiftwidth.
func! s:nestLevel(lineNr) abort
    return strlen(matchstr(getline(a:lineNr), "^ *")) / &shiftwidth
endfunc

" The character that starts an item is a flag with following meanings:
" X :: To-do item that has been abandoned (like 'wontfix')
" / :: Finished to-do item
" ? :: A note that is a question
" @ :: A context for next actions
" - :: Everything else (unfinished to-do items, notes, etc.)
" ! :: Hi-pri or answers to questions
"
func! s:itemStartsOn(lineNr) abort
    return match(getline(a:lineNr), '^ *[-/X\?@!] ') >= 0
endfunc

" Get the next nest level.
func! s:nextLevel(lineNr) abort
    return s:nestLevel(s:nextItem(a:lineNr))
endfunc

" Does an item have sub items?
"
" Find the next item and see if its depth is greater.
func! s:itemHasSubItems(lineNr, curDepth) abort
    let nextItemLineNr = s:nextItem(a:lineNr)
    return nextItemLineNr != -1 && s:nestLevel(nextItemLineNr) > a:curDepth
endfunc

" Here I avoid using search(), which requires moving the cursor.
func! s:nextItem(lineNr) abort
    let lastBufLine = getpos('$')[1]

    let lineNr = a:lineNr + 1
    while lineNr <= lastBufLine && ! s:itemStartsOn(lineNr)
        let lineNr = lineNr + 1
    endwhile

    let nextItemLine = -1
    if lineNr <= lastBufLine
        let nextItemLine = lineNr
    endif
    return nextItemLine
endfunc

function! InboxFoldText() abort
    let childCt = s:countChildItems(v:foldstart, v:foldend)
    " Add ellipsis if first item wraps
    let ellipsis = ''
    if childCt > 0 && s:nextItem(v:foldstart) !=# v:foldstart + 1
        let ellipsis = '…'
    endif
    return substitute(
        \ substitute(
            \ getline(v:foldstart),
            \ '-',
            \ '+', ''),
        \ '\s*$',
        \ ellipsis . ' (↓'.childCt.')', '')
endfunc

" Only counts direct descendents, not grandchildren.
function! s:countChildItems(foldstart, foldend)
    let childDepth = s:nestLevel(a:foldstart) + 1
    let lineNr = a:foldstart + 1
    let childCt = 0
    while lineNr <= a:foldend
        if s:itemStartsOn(lineNr) && s:nestLevel(lineNr) ==# childDepth
            let childCt = childCt + 1
        endif
        let lineNr = lineNr + 1
    endwhile
    return childCt
endfunc

command! -range -buffer SI echo s:countChildItems(<line1>, <line2>)
command! -range -buffer NL echo s:nestLevel(<line1>)
command! -range -buffer NI echo s:nextItem(<line1>)
command! -range -buffer FD echo InboxFoldDepth(<line1>)
command! -range -buffer IS echo s:itemStartsOn(<line1>)
command! -range -buffer HS echo s:itemHasSubItems(<line1>, <line2>)

setl foldmethod=expr
setl foldexpr=InboxFoldDepth(v:lnum)
setl foldtext=InboxFoldText()
