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

imap <unique> <buffer> <cr> <Plug>ViminNewItem
