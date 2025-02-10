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
    let l:commentOutput = ingo#plugin#setting#GetBufferLocal('asciinema_CommentPrefix') . a:comment . ingo#plugin#setting#GetBufferLocal('asciinema_CommentSuffix')
    return ft#asciinema#CreateRelativeRecord(0.0, 0.0, printf(' "o", %s', json_encode(s:KeepCursorPosition(l:commentOutput))))
endfunction

function! s:KeepCursorPosition( text ) abort
    return ingo#plugin#setting#GetBufferLocal('asciinema_SaveCursorPosition') . a:text . ingo#plugin#setting#GetBufferLocal('asciinema_RestoreCursorPosition')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
