if exists("g:loaded_vimin_plugin")
    finish
endif
let g:loaded_vimin_plugin = 1

inoremap <unique> <script> <Plug>ViminNewItem <SID>NewItem
inoremap <SID>NewItem <esc>:call vimin#new_item()<cr>

noremap <Plug>ViminNewAbove <esc>:call vimin#new_item_above()<cr>
