" asciinema.vim: Settings for asciinema terminal session recordings
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:   Ingo Karkat <ingo@karkat.de>
scriptencoding utf-8

" Avoid installing twice or when in compatible mode
if exists('b:did_ftplugin') | finish | endif

"- configuration ---------------------------------------------------------------

if ! exists('g:asciinema_CommentPrefix')
    let g:asciinema_CommentPrefix = "\e[48;5;55;38;5;195m“"
endif
if ! exists('g:asciinema_CommentSuffix')
    let g:asciinema_CommentSuffix = "”\e[0m"
endif
if ! exists('g:asciinema_TimedCommentDuration')
    let g:asciinema_TimedCommentDuration = 3
endif
if ! exists('g:asciinema_TimedCommentMinDuration')
    let g:asciinema_TimedCommentMinDuration = 0.9
endif

if ! exists('g:asciinema_SaveCursorPosition')
    let g:asciinema_SaveCursorPosition = "\e[s"
endif
if ! exists('g:asciinema_RestoreCursorPosition')
    let g:asciinema_RestoreCursorPosition = "\e[u"
endif


"- commands --------------------------------------------------------------------

command! -buffer -nargs=? AsciinemaInsertMarker
\   call setline('.', getline('.')) | call ingo#lines#PutWrapper('.', 'put!', ft#asciinema#insert#CreateMarker(<q-args>))
command! -buffer -nargs=1 AsciinemaInsertCommentAtCursor
\   call setline('.', getline('.')) | call ingo#lines#PutWrapper('.', 'put', ft#asciinema#insert#CreateComment(<q-args>))
command! -buffer -nargs=1 AsciinemaInsertCommentAndMarkerAtCursor
\   call setline('.', getline('.')) | call ingo#lines#PutWrapper('.', 'put', [ft#asciinema#insert#CreateMarker(<q-args>), ft#asciinema#insert#CreateComment(<q-args>)])

command! -buffer -nargs=1 AsciinemaInsertTimedCommentAtCursor
\   call setline('.', getline('.')) | if ! ft#asciinema#insert#InsertTimedComment(<q-args>) | echoerr ingo#err#Get() | endif
command! -buffer -nargs=1 AsciinemaExtendTimedCommentAtCursor
\   call setline('.', getline('.')) | call ingo#lines#PutWrapper('.', 'put', ft#asciinema#insert#CreateTimedComment(<q-args>, ingo#plugin#setting#GetBufferLocal('asciinema_TimedCommentDuration')))



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
