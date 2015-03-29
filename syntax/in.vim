syn sync fromstart
syn match inItemComment /^\s*> .*$/ contains=inItemCommentLdr display
syn match inItemCommentLdr /^\s*\zs> / contained display nextgroup=inItemCommentTxt
syn match inItemCommentTxt /.*$/ contained display
hi inItemCommentTxt cterm=italic
hi inItemCommentLdr ctermfg=10
