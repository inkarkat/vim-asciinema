" ft/asciinema.vim: Functions for the asciinema filetype.
"
" DEPENDENCIES:
"
" Copyright: (C) 2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:RenderTime( time, spacer ) abort
    return substitute(
    \   substitute(
    \       printf('%.6f', a:time),
    \       '0\%(0*$\)\@=', a:spacer, 'g'),
    \   '\.\ze *$', a:spacer, ''
    \)
endfunction

function! s:IsModifiable() abort
    return ! &l:readonly && &l:modifiable
endfunction

function! ft#asciinema#Relativize() abort
    if ! s:IsModifiable()
	return
    endif

    let l:prevTime = 0.0
    for l:lnum in range(1, line('$'))
	let l:parse = matchlist(getline(l:lnum), '^\[\(\d\+\%(\.\d*\)\?\)\(\s*,\)\(.*\)\]$')
	if empty(l:parse)
	    continue
	endif

	let l:curTime = str2float(l:parse[1])
	if (l:curTime < l:prevTime)
	    continue
	endif

	call setline(l:lnum, printf('[+%s,%11s,%s]', s:RenderTime(l:curTime - l:prevTime, ' '), s:RenderTime(l:curTime, ' '), l:parse[3]))
	let l:prevTime = l:curTime
    endfor
endfunction

function! ft#asciinema#Unrelativize() abort
    if ! s:IsModifiable()
	return
    endif

    let l:prevTime = 0.0
    for l:lnum in range(1, line('$'))
	let l:parse = matchlist(getline(l:lnum), '^\[\s*+\(\d\+\%(\.\d*\)\?\)\s*,\s*\(\d\+\%(\.\d*\)\?\)\s*,\(.*\)\]$')
	if empty(l:parse)
	    let l:parse = matchlist(getline(l:lnum), '^\[\(\d\+\%(\.\d*\)\?\)\(\s*,\)\(.*\)\]$')
	    if empty(l:parse)
		continue
	    endif
	    " Time offset got removed; re-sync to the original absolute time.
	    let l:curTime = str2float(l:parse[1])
	    " If that would go back in time due to increased previous offsets, bump it to
	    " the previous time.
	    if l:curTime < l:prevTime
		let l:curTime = l:prevTime
	    endif
	else
	    let l:timeDelta = str2float(l:parse[1])
	    let l:curTime = l:prevTime + l:timeDelta
	endif

	call setline(l:lnum, printf('[%s,%s]', s:RenderTime(l:curTime, ''), l:parse[3]))
	let l:prevTime = l:curTime
    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
