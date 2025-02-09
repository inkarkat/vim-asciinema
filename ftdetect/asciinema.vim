" Vim filetype detection file
" Language:	asciinema terminal session recordings
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Copyright: (C) 2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.

autocmd BufNewFile,BufRead *.cast set filetype=asciinema
