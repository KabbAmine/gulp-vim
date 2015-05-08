" A simple gulp wrapper for vim
" Version     : 0.2
" Creation    : 2015-03-18
" Last Change : 2015-05-08
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
" {{{1
command -nargs=* -complete=custom,s:CompleteTaskNames Gulp :echo s:Gulp(<f-args>)
command -nargs=* -complete=custom,s:CompleteTaskNames GulpExt :call s:GulpExternal(<f-args>)
command GulpTasks :echo s:GetTaskNames()
" }}}

" VARIABLES
" =====================================================================
" Get used OS & dir separator {{{1
if has('unix')
	let s:os = 'unix' | let s:sep = '/'
elseif has('win32')
	let s:os = 'win32' | let s:sep = '\'
endif
" Add --no-color flag if gui vim is used {{{1
let s:gulpCliFlags = has('gui_running') ? ' --no-color' : ''
" Rvm hack for unix (Source rvm script file if it exists when using an external terminal) {{{1
" http://stackoverflow.com/a/8493284
let s:rvmHack = exists('g:gv_rvm_hack') ? '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" && ' : ''
" Return to prompt option {{{1
if exists('g:gv_return_2_prompt')
	let s:prompt = {
				\ 'unix': ' exec bash',
				\ 'win32': ' /k'
				\ }
else
	let s:prompt = {
				\ 'unix': '',
				\ 'win32': ' /c'
				\ }
endif
" Command line for executing external terminal {{{1
let s:termCmd = {
			\ 'unix': {
				\ 'h': 'exo-open --launch TerminalEmulator ',
				\ 'b': ' bash -c "' . s:rvmHack,
				\ 't': ' ; ' . s:prompt.unix . '" & '
			\ },
			\ 'win32': {
				\ 'h': 'start cmd ' . s:prompt.win32 . ' ',
				\ 'b': '',
				\ 't': ' & '
			\ }
		\}
" }}}

" FUNCTIONS
" =====================================================================
function s:HasGulpfile() " {{{1
	return filereadable(getcwd() . s:sep . 'gulpfile.js')
endfunction
function s:Gulp(...) " {{{1
	" Execute gulp with given param(s) as task name(s) (By default is 'default' :D)
	
	let l:task = a:0 >=# 1 ? join(a:000, ' ') : 'default'
	return s:HasGulpfile() ? system('gulp ' . l:task . s:gulpCliFlags) : 'No gulpfile.js in the current directory'
endfunction
function s:GulpExternal(...) " {{{1
	" Execute gulp with given param(s) as task name(s) in external terminal.

	let l:task = a:0 >=# 1 ? join(a:000, ' ') : 'default'
	if s:HasGulpfile()
		exec 'silent :!' . s:termCmd[s:os].h . s:termCmd[s:os].b . 'gulp ' . l:task . s:termCmd[s:os].t
	else
		echo 'No gulpfile.js in the current directory'
	endif
endfunction
function s:GetTaskNames() " {{{1
	" Return a string list of task names from gulpfile.js (If he exists).

	if s:HasGulpfile()
		let l:tasks = []
		for l:line in readfile('gulpfile.js')
			" Get only lines with gulp.task
			if l:line =~# '^gulp.task'
				" Get task name & add it to a list of tasks
				let l:task = l:line[match(l:line, "'", 0, 1) + 1 : match(l:line, "'", 0, 2) - 1]
				call add(l:tasks, l:task)
			endif
		endfor
		return join(l:tasks, "\n") . "\n"
	else
		return 'No gulpfile.js in the current directory'
	endif

endfunction
" }}}
function s:CompleteTaskNames(A, L, P) " {{{1
	return s:GetTaskNames()
endfunction
" }}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
let &fileformat = s:saveFileFormat
" }}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
