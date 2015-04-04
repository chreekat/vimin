syn sync fromstart

syn match inItemComment /^\s*> .*$/ contains=inItemCommentLdr display
syn match inItemCommentLdr /^\s*\zs> / contained display nextgroup=inItemCommentTxt
syn match inItemCommentTxt /.*$/ contained display

syn match inNA /\c\[next action\]/ display
syn match inNA /\c- \zsnext action:/ display
syn match inOutcome /\c\[outcome\]/ display
syn match inOutcome /\c- \zsoutcome:/ display

hi inNA             ctermfg=5
hi inOutcome        ctermfg=2
hi inItemCommentTxt cterm=italic
hi inItemCommentLdr ctermfg=10
