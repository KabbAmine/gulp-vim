" A simple gulp wrapper for vim
" Version     : 0.8.4
" Creation    : 2015-03-18
" Last Change : 2016-11-07
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

" OPTIONS
" =====================================================================
" Default gulpfile {{{1
let g:gv_default_gulpfile = get(g:, 'gv_default_gulpfile', 'gulpfile.js')
" Close terminal after task execution {{{1
let g:gv_return_2_prompt = get(g:, 'return_2_prompt', 0)
" Source rvm before executing a task {{{1
let g:gv_rvm_hack = get(g:, 'gv_rvm_hack', 0)
" Plugin integrations {{{1
let g:gv_ctrlp_cmd = get(g:, 'gv_ctrlp_cmd', 'Gulp')
let g:gv_unite_cmd = get(g:, 'gv_unite_cmd', 'Gulp')
" N.B: Will be removed in 1.0
let g:gv_use_dispatch = get(g:, 'gv_use_dispatch', 1)
" 1}}}

" COMMANDS
" =====================================================================
" Main {{{1
command! -nargs=* -complete=custom,<SID>CompleteTasks Gulp :call gulpVim#Call('gulpVim#Execute', 'e', <f-args>)
command! -nargs=* -complete=custom,<SID>CompleteTasks GulpExt :call gulpVim#Call('gulpVim#Run', 'c', <f-args>)
command! GulpTasks :call gulpVim#Call('gulpVim#GetTasks', 'e', 1)
command! -nargs=? -complete=file GulpFile :call gulpVim#GulpFile(<f-args>)
" CTRLP {{{1
command! CtrlPGulp
			\ if exists(':CtrlP') ==# 2
				\| call ctrlp#init(ctrlp#gulp#id())
			\| endif
" }}}

" FUNCTIONS
" =====================================================================
function! <SID>CompleteTasks(A, L, P) abort " {{{1
	if gulpVim#GulpFile(g:gv_default_gulpfile)
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
