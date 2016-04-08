syn sync minlines=50

syn match inComment /^\s*[>"].*"\?$/ contains=inCommentLdr1,inCommentLdr2 display
syn match inCommentLdr1 /^\s*\zs>\ze / contained display conceal cchar=  nextgroup=inCommentTxt
syn match inCommentLdr2 /^\s*\zs"/ contained display conceal cchar=  nextgroup=inCommentTxt
syn match inCommentTxt /.\{-}\ze"\?$/ contained display nextgroup=inCommentFtr
syn match inCommentFtr /"\?/ contained display conceal cchar=  "space

syn match inNA /\c- \zsnext action:/ display
syn match inPrinciples /\c- \zsprinciples:/ display
syn match inOutcome /\c- \zsoutcome:/ display
syn match inWF /\c- \zswaiting for:/ display

syn match inQuestion /^\s*\zs?\ze / display
syn match inHiPri /^\s*\zs!\ze / display
syn match inFinished /^\s*\zs\/\ze / display conceal cchar=✓
syn match inBold /\*\*\S.*\S\*\*/ display contains=inBoldMarker
syn match inBoldMarker /\*\*/ contained display conceal

func! s:highlighting()
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
endfunc

call s:highlighting()

augroup InSyntax
    au!
    au ColorScheme <buffer> call s:highlighting()
augroup END
