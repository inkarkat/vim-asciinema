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

function! ft#asciinema#insert#CreateComment( comment ) abort
    return ft#asciinema#CreateRelativeRecord(0.0, 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(s:MakeCommentOutput(a:comment)))))
endfunction

function! ft#asciinema#insert#CreateTimedComment( comment ) abort
    let l:commentOutput = s:MakeCommentOutput(a:comment)
    let l:clearOutput = substitute(s:RemoveAnsiEscapes(l:commentOutput), '.', ' ', 'g')
    return [
    \   ft#asciinema#CreateRelativeRecord(0.0, 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(l:commentOutput)))),
    \   ft#asciinema#CreateRelativeRecord(ingo#plugin#setting#GetBufferLocal('asciinema_TimedCommentDuration'), 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(l:clearOutput)))),
    \]
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

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
