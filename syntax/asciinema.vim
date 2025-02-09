" Vim syntax file
" Language:	asciinema terminal session recordings
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Copyright: (C) 2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
scriptencoding utf-8

" Quit when a syntax file was already loaded.
if exists('b:current_syntax') | finish | endif

syntax include @asciinemaJson syntax/json.vim
syntax match asciinemaMeta "\%1l^{.*}" contains=@asciinemaJson

syntax match asciinemaMarker '^\[\%(+[^,]\+,\s*\)\?[^,]\+,\s*"m",\s*.*\]$' contains=asciinemaOpenBracket,asciinemaCloseQuoteAndBracket
syntax match asciinemaOutput '^\[\%(+[^,]\+,\s*\)\?[^,]\+,\s*"o",\s*.*\]$' contains=asciinemaOpenBracket,asciinemaCloseQuoteAndBracket,asciinemaAnsiEscape,asciinemaSpecial

syntax match asciinemaOpenBracket "^\[" contained skipwhite nextgroup=asciinemaSmallTimeOffset,asciinemaLargeTimeOffset,asciinemaTimestamp
syntax match asciinemaSmallTimeOffset "+0\%(\.\d*\)\?" contained skipwhite nextgroup=asciinemaTimeOffsetComma
syntax match asciinemaLargeTimeOffset "+[1-9]\d*\%(\.\d*\)\?" contained skipwhite nextgroup=asciinemaTimeOffsetComma
syntax match asciinemaTimeOffsetComma "," contained skipwhite nextgroup=asciinemaTimestamp
syntax match asciinemaTimestamp "\d\+\%(\.\d*\)\?" contained skipwhite nextgroup=asciinemaType
syntax match asciinemaType ',\s*"\l",' contained skipwhite nextgroup=asciinemaOpenQuote
syntax match asciinemaOpenQuote '"'
syntax match asciinemaCloseQuoteAndBracket '"\]$' contained

syntax match asciinemaAnsiEscape "\\u001b\[[0-9:;?]*[[:alpha:]]" contained contains=asciinemaEscape
syntax match asciinemaEscape "\\u001b" contained contains=asciinemaEscapeConceal1
if has('conceal')
    syntax match asciinemaEscapeConceal1 "\\" contained conceal cchar=^ nextgroup=asciinemaEscapeConceal2
    syntax match asciinemaEscapeConceal2 "u001b" contained conceal cchar=[
endif

syntax match asciinemaSpecial "\\[rn]" contained


highlight def link asciinemaMeta PreProc
highlight def link asciinemaOpenBracket NonText
highlight def link asciinemaCloseBracket NonText
highlight def link asciinemaType NonText
highlight def link asciinemaOpenQuote NonText
highlight def link asciinemaCloseQuoteAndBracket NonText
highlight def link asciinemaMarker Label
highlight def link asciinemaTimestamp Number
highlight def link asciinemaSmallTimeOffset Constant
highlight def link asciinemaLargeTimeOffset Type
highlight def link asciinemaEscape SpecialKey
highlight def link asciinemaEscapeConceal1 asciinemaEscape
highlight def link asciinemaEscapeConceal2 asciinemaEscape
highlight def link asciinemaAnsiEscape asciinemaEscape
highlight def link asciinemaSpecial Special

let b:current_syntax = 'asciinema'

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
