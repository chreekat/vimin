syn sync fromstart

syn match inComment /^\s*> .*$/ contains=inCommentLdr display
syn match inCommentLdr /^\s*\zs>\ze / contained display conceal cchar=  nextgroup=inCommentTxt
syn match inCommentTxt /.*$/ contained display

syn match inNA /\c- \zsnext action:/ display
syn match inPrinciples /\c- \zsprinciples:/ display
syn match inOutcome /\c- \zsoutcome:/ display
syn match inWF /\c- \zswaiting for:/ display

syn match inQuestion /^\s*\zs?/ display
syn match inHiPri /^\s*\zs!/ display

syn match inBold /\*\*\w\+\*\*/ display contains=inBoldMarker
syn match inBoldMarker /\*\*/ contained display conceal

hi inBold           cterm=bold
hi inNA             ctermfg=5
hi inPrinciples     ctermfg=4
hi inOutcome        ctermfg=2
hi inCommentTxt     cterm=italic
hi clear inQuestion
hi inQuestion       cterm=reverse ctermfg=4
hi inHiPri          cterm=reverse ctermfg=1
hi inWF             ctermfg=1
hi clear Folded
