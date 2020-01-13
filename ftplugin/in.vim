" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

runtime! ftplugin/markdown.vim ftplugin/markdown_*.vim ftplugin/markdown/*.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|iunmap <buffer> <cr>|iunmap <script> <Plug>ViminNewItem"
  let b:undo_ftplugin .= "|setl com< fdm< fo< ic< sw< sc<"
else
  let b:undo_ftplugin = "iunmap <buffer> <cr>|iunmap <script> <Plug>ViminNewItem"
  let b:undo_ftplugin .= "|setl com< fdm< fo< ic< sw< sc<"
endif

setlocal foldmethod=indent
setlocal formatoptions=tcqnl1jo
setlocal ignorecase
setlocal shiftwidth=4
setlocal smartcase

imap <unique> <buffer> <cr> <Plug>ViminNewItem
nnoremap <unique> <buffer> I ^wi
nmap <localleader>o A<cr>
