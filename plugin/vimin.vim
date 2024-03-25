if exists("g:loaded_vimin_plugin")
    finish
endif
let g:loaded_vimin_plugin = 1

inoremap <unique> <script> <Plug>ViminNewItem <SID>NewItem
inoremap <SID>NewItem <esc>:call vimin#new_item()<cr>

noremap <Plug>ViminNewAbove <esc>:call vimin#new_item_above()<cr>

inoremap <unique> <script> <Plug>ViminBackspace <SID>Backspace
inoremap <SID>Backspace <esc>:call vimin#backspace()<cr>

onoremap <unique> <script> <Plug>ViminOperateItem <SID>OperateItem
onoremap <SID>OperateItem :call vimin#operate_item()<cr>
