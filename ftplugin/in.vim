" Only do this when not done yet for this buffer
if exists("b:did_in_ftplugin")
    finish
endif
let b:did_in_ftplugin=1
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|iunmap <buffer> <cr>|iunmap <script> <Plug>ViminNewItem"
  let b:undo_ftplugin .= "|setl com< fdm< fo< ic< sw< sc<"
else
  let b:undo_ftplugin = "iunmap <buffer> <cr>|iunmap <script> <Plug>ViminNewItem"
  let b:undo_ftplugin .= "|setl com< fdm< fo< ic< sw< sc<"
endif

setlocal comments=f:-\ \ ,:>
setlocal foldmethod=indent
setlocal formatoptions=tcqnl1jo
setlocal ignorecase
setlocal shiftwidth=4
setlocal smartcase

imap <unique> <buffer> <cr> <Plug>ViminNewItem
nnoremap <unique> <buffer> I ^wi
nmap <localleader>o A<cr>
