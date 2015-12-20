" A simple gulp wrapper for vim
" Version     : 0.8.1
" Creation    : 2015-03-18
" Last Change : 2015-12-20
" Maintainer  : Kabbaj Amine <amine.kabb@gmail.com>
" License     : This file is placed in the public domain.

" Vim options {{{1
if exists('g:gulp_vim_loaded')
	finish
endif
let g:gulp_vim_loaded = 1

" To avoid conflict problems.
let s:saveFileFormat = &fileformat
let s:saveCpoptions = &cpoptions
set fileformat=unix
set cpoptions&vim
" }}}

" COMMANDS
" =====================================================================
" Main {{{1
command! -nargs=* -complete=custom,<SID>CompleteTasks Gulp :call gulpVim#Call('gulpVim#Execute', 'e', <f-args>)
command! -nargs=* -complete=custom,<SID>CompleteTasks GulpExt :call gulpVim#Call('gulpVim#Run', 'c', <f-args>)
command! GulpTasks :call gulpVim#Call('gulpVim#GetTasks', 'e')
command! -nargs=? -complete=file GulpFile :call gulpVim#CheckGulpFile(<f-args>)
" CTRLP {{{1
command! CtrlPGulp
			\ if exists(':CtrlP') ==# 2
				\| call ctrlp#init(ctrlp#gulp#id())
			\| endif
" }}}

" FUNCTIONS
" =====================================================================
function! <SID>CompleteTasks(A, L, P) abort " {{{1
	if gulpVim#CheckGulpFile(g:gv_default_gulpfile)
		return gulpVim#GetTasks()
	endif
endfunction
" }}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
let &fileformat = s:saveFileFormat
unlet s:saveFileFormat
" }}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
