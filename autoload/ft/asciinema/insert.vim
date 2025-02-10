" ft/asciinema/insert.vim: Insert comments and markers.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! ft#asciinema#insert#CreateMarker( label ) abort
    return ft#asciinema#CreateRelativeRecord(0.0, 0.0, printf(' "m", %s', json_encode(a:label)))
endfunction

function! ft#asciinema#insert#CreateComment( comment, ... ) abort
    let l:repositioning = a:0 ? a:1 : ''
    return ft#asciinema#CreateRelativeRecord(0.0, 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(l:repositioning . s:MakeCommentOutput(a:comment)))))
endfunction

function! ft#asciinema#insert#CreateTimedComment( comment, clearDelay, ... ) abort
    let l:repositioning = a:0 ? a:1 : ''
    let l:commentOutput = s:MakeCommentOutput(a:comment)
    let l:clearOutput = substitute(s:RemoveAnsiEscapes(l:commentOutput), '.', ' ', 'g')
    return [
    \   ft#asciinema#CreateRelativeRecord(0.0, 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(l:repositioning . l:commentOutput)))),
    \   ft#asciinema#CreateRelativeRecord(a:clearDelay, 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(l:repositioning . l:clearOutput)))),
    \]
endfunction

function! ft#asciinema#insert#InsertTimedComment( comment ) abort
    let l:followingLnum = line('.') + 1
    let l:parse = ft#asciinema#ParseRelativizedRecord(l:followingLnum)
    if empty(l:parse)
	call ingo#err#Set('No following record found')
	return 0
    endif
    let l:timeDelta = str2float(l:parse[1])
    if l:timeDelta < ingo#plugin#setting#GetBufferLocal('asciinema_TimedCommentMinDuration')
	call ingo#err#Set(printf('Following record is too close; use :%s instead.', 'AsciinemaExtendTimedCommentAtCursor'))
	return 0
    endif

    let l:clearDelay = s:Min(l:timeDelta, ingo#plugin#setting#GetBufferLocal('asciinema_TimedCommentDuration'))
    call setline(l:followingLnum, ft#asciinema#CreateRelativeRecord(l:timeDelta - l:clearDelay, 0.0, l:parse[3]))
    call ingo#lines#PutWrapper(l:followingLnum, 'put!', ft#asciinema#insert#CreateTimedComment(a:comment, l:clearDelay))
    return 1
endfunction

function! ft#asciinema#insert#Repositioning( count, line1, line2 ) abort
    let l:position = (a:count == -1
    \   ? ingo#plugin#setting#GetBufferLocal('asciinema_DefaultPosition')
    \   : a:line1 == a:line2
    \       ? [a:line1, 1]
    \       : [a:line1, a:line2]
    \)
    return printf(ingo#plugin#setting#GetBufferLocal('asciinema_SetCursorPosition'), l:position[0], l:position[1])
endfunction
function! s:MakeCommentOutput( comment ) abort
    return ingo#plugin#setting#GetBufferLocal('asciinema_CommentPrefix') . a:comment . ingo#plugin#setting#GetBufferLocal('asciinema_CommentSuffix')
endfunction

function! s:KeepCursorPosition( text ) abort
    return ingo#plugin#setting#GetBufferLocal('asciinema_SaveCursorPosition') . a:text . ingo#plugin#setting#GetBufferLocal('asciinema_RestoreCursorPosition')
endfunction

function! s:RemoveAnsiEscapes( text ) abort
    return substitute(a:text, '\e\[[0-9:;?]*\a', '', 'g')
endfunction

function! s:Min( a, b ) abort   " XXX: min() doesn't support floats
    return (a:a <= a:b ? a:a : a:b)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
