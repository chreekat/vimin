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

let b:undo_ftplugin .= "iunmap <buffer> <cr>"
let b:undo_ftplugin .= "|iunmap <buffer> <BS>"
let b:undo_ftplugin .= "|iunmap <buffer> <Tab>"
let b:undo_ftplugin .= "|iunmap <buffer> <S-Tab>"
let b:undo_ftplugin .= "|nunmap <buffer> I"
let b:undo_ftplugin .= "|nunmap <buffer> o"
let b:undo_ftplugin .= "|nunmap <buffer> O"

let b:undo_ftplugin .= "|setl fdm< fo< ic< sw< sc< fdi<"

setlocal foldmethod=indent
" Aha! Lines starting with # are ignored by default with fdm=indent, which
" probably explains a lot of weird behavior over the years. Configurable with
" fdi.
setlocal foldignore=
setlocal foldtext=vimin#foldtext()
setlocal formatoptions=tcqnl1jo
setlocal ignorecase
setlocal shiftwidth=4
setlocal smartcase
" Identify "/" as a list start (it means "done item")
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*/]\ \\ze\\s*
" Lots of indenting calls for a wider textwidth
if &textwidth < 100
    setlocal textwidth=100
endif

imap <buffer> <cr> <Plug>ViminNewItem
imap <buffer> <BS> <Plug>ViminBackspace
imap <buffer> <Tab> <C-t>
imap <buffer> <S-Tab> <C-d>
nnoremap <unique> <buffer> I ^wi
nmap <buffer> o A<cr>
nmap <buffer> O <Plug>ViminNewAbove

onoremap <buffer> ai <Plug>ViminOperateItem
