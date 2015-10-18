" A simple gulp wrapper for vim
" Version     : 0.2
" Creation    : 2015-03-18
" Last Change : 2015-10-18
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
command -nargs=* -complete=custom,s:CompleteTaskNames Gulp :call s:ExecCmd('s:Gulp', 'e', <f-args>)
command -nargs=* -complete=custom,s:CompleteTaskNames GulpExt :call s:ExecCmd('s:GulpExternal', 'c', <f-args>)
command GulpTasks :call s:ExecCmd('s:GetTaskNames', 'e')
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
	" Return gulp execution with given param(s) as task name(s) (By default is 'default' :D)

	let l:tasks = a:0 >=# 1 ? join(a:000, ' ') : 'default'
	return system('gulp ' . l:tasks . s:gulpCliFlags)
endfunction
function s:GulpExternal(...) " {{{1
	" Return gulp execution with given param(s) as task name(s) in external terminal.

	let l:tasks = a:0 >=# 1 ? join(a:000, ' ') : 'default'
	return 'silent :!' . s:termCmd[s:os].h . s:termCmd[s:os].b . 'gulp ' . l:tasks . s:termCmd[s:os].t
endfunction
function s:GetTaskNames() " {{{1
	" Return task names as strings from gulpfile.js

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

endfunction
" }}}
function s:ExecCmd(funName, action, ...) " {{{1
	" Automate the vim command creation:
	"	- Check gulpfile presence
	"	- Echo or execute when needed

	let l:args = exists('a:000') ? a:000 : []
	if s:HasGulpfile()
		if a:action ==# 'e'
			echo call(a:funName, l:args)
		else
			exec call(a:funName, l:args)
		endif
	else
		echohl Error | echo 'No gulpfile.js in the current directory' | echohl None
	endif
endfunction
function s:CompleteTaskNames(A, L, P) " {{{1
	if s:HasGulpfile()
		return s:GetTaskNames()
	endif
endfunction
" }}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
let &fileformat = s:saveFileFormat
" }}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
