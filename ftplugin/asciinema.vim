" asciinema.vim: Settings for asciinema terminal session recordings
"
" DEPENDENCIES:
"
" Copyright: (C) 2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:   Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in compatible mode
if exists('b:did_ftplugin') | finish | endif

"- autocmds --------------------------------------------------------------------

augroup asciinema
    autocmd! BufReadPost,BufWritePost <buffer>  call ft#asciinema#Relativize()
    autocmd! BufWritePre <buffer>               call ft#asciinema#Unrelativize()
augroup END
call ft#asciinema#Relativize()



"- settings --------------------------------------------------------------------

" The matchparen plugin slows down cursor movement in long JSON lines, and the
" matching isn't that useful here, anyway.
silent! NoMatchParen

let b:did_ftplugin = 1

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
