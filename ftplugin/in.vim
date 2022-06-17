" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

runtime! ftplugin/markdown.vim ftplugin/markdown_*.vim ftplugin/markdown/*.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|"
else
  let b:undo_ftplugin = ""
endif
let b:undo_ftplugin .= "iunmap <buffer> <cr>|nunmap <buffer> I"
let b:undo_ftplugin .= "|setl fdm< fo< ic< sw< sc<"

setlocal foldmethod=indent
setlocal foldtext=vimin#foldtext()
setlocal formatoptions=tcqnl1jo
setlocal ignorecase
setlocal shiftwidth=4
setlocal smartcase

imap <buffer> <cr> <Plug>ViminNewItem
nnoremap <unique> <buffer> I ^wi
nmap <localleader>o A<cr>
