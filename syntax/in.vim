syn sync fromstart

syn match inItemComment /^\s*> .*$/ contains=inItemCommentLdr display
syn match inItemCommentLdr /^\s*\zs> / contained display nextgroup=inItemCommentTxt
syn match inItemCommentTxt /.*$/ contained display

syn match inNA /\[next action\]/ display

hi inNA             ctermfg=5
hi inItemCommentTxt cterm=italic
hi inItemCommentLdr ctermfg=10
