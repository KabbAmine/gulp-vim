" Creation    : 2015-12-20
" Last Change : 2016-11-07

" VARIABLES
" =====================================================================
" Get informations specific to OS {{{1
let s:os = {
			\ 'name'      : (has('unix') ? 'unix' : 'win32'),
			\ 'sep'       : (has('unix') ? '/'    : '\'),
			\ 'and'       : (has('unix') ? '&&'   : '&'),
			\ 'root'      : (has('unix') ? '^/'   : '^\a:')
		\ }
" A dictionnary for the shell command {{{1
let s:shell = {}
let s:shell.flags = has('gui_running') ? '--no-color' : ''
let s:shell.rvm = g:gv_rvm_hack && has('unix') ?
			\	'[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" &&' :
			\	''
let s:shell.prompt = g:gv_return_2_prompt ?
			\ {'unix': ' exec bash', 'win32': ' /k' } :
			\ {'unix': '', 'win32': ' /c'}
let s:shell.cmd = {
			\ 'unix' : 'exo-open --launch TerminalEmulator bash -c "' . s:shell.rvm . ' %s ; ' . s:shell.prompt.unix . '" &',
			\ 'win32': 'start cmd ' . s:shell.prompt.win32 . ' %s &'
		\ }
" 1}}}

" FUNCTIONS
" =====================================================================
function! gulpVim#GulpFile(...) abort "{{{1

	let l:gf = exists('a:1') ? a:1 : 'gulpfile.js'
	if l:gf !~# '\v^.*gulpfile\.(((babel\.)?js)|(coffee))$'
		echohl Error | echo l:gf . ' is not a valid gulpfile' | echohl None
		return 0
	endif
	" First check if the gulpfile was given with a path
	if filereadable(l:gf)
		let g:gv_default_gulpfile = l:gf
		return 1
	endif
	let l:tgf = findfile(l:gf, '.;')
	if !empty(l:tgf)
		let g:gv_default_gulpfile = l:tgf
		return 1
	endif
	return 0
endfunction
function! gulpVim#SetCustomCommand(custom, gulp) abort " {{{1
	" Return parsed custom command (If custom[1] == 1, escape double
	" quotes in gulp command).

	let l:gc = printf('cd %s %s %s', shellescape(getcwd()), s:os.and, a:gulp)
	if type(a:custom) ==# type('')
		" To be compatible with old versions, may be removed in 1.0.0
		return printf(a:custom, l:gc)
	elseif type(a:custom) ==# type([])
		if a:custom[1] ==# 0
			return printf(a:custom[0], l:gc)
		elseif a:custom[1] ==# 1
			return printf(a:custom[0], escape(l:gc, '"'))
		endif
	endif
endfun
function! gulpVim#Execute(...) abort " {{{1
	" Return gulp execution with given param(s) as task name(s) (By default is 'default' :D)

	let l:tasks = a:0 >=# 1 ? join(a:000, ' ') : 'default'
	echohl Title | echo 'Execute task(s) -> ' . l:tasks . ':' | echohl None
	let l:flags = printf('--gulpfile %s %s', shellescape(g:gv_default_gulpfile), s:shell.flags)
	return system(printf('%s gulp %s %s', s:shell.rvm, l:tasks, l:flags))
endfunction
function! gulpVim#Run(...) abort " {{{1
	" Return parsed gulp execution command with given param(s) as task name(s)
	" in external terminal.

	let l:tasks = a:0 >=# 1 ? join(a:000, ' ') : 'default'
	let l:flags = '--gulpfile ' . shellescape(g:gv_default_gulpfile)
	let l:focus = has('unix') && executable('wmctrl') && v:windowid !=# 0 ?
				\ 'wmctrl -ia ' . v:windowid . ';' : ''
	let l:gc = printf('%s %s gulp %s %s', l:focus, s:shell.rvm, l:tasks, l:flags)
	if exists('g:gv_custom_cmd')
		return gulpVim#SetCustomCommand(g:gv_custom_cmd, l:gc)
	" WILL BE REMOVED ===========================
	elseif g:gv_use_dispatch && exists(':Start')
		return printf('Start! %s', l:gc)
	" ===========================================
	else
		let l:gc = escape(printf('%s gulp %s %s', l:focus, l:tasks, l:flags), '"')
		return printf('silent :!%s', printf(s:shell.cmd[s:os.name], l:gc))
	endif
endfunction
function! gulpVim#GetTasks(...) abort " {{{1
	" Return task names as strings from gulpfile
	" Echo msg if a:1 exists

	let l:tasks = []
	if !gulpVim#GulpFile(g:gv_default_gulpfile)
		return 0
	endif
	for l:line in readfile(g:gv_default_gulpfile)
		if l:line =~# '\v^\s?gulp.task'
			" Get task name & add it to a list of tasks
			let l:task = l:line[match(l:line, "'", 0, 1) + 1 : match(l:line, "'", 0, 2) - 1]
			call add(l:tasks, l:task)
		endif
	endfor
	if exists('a:1')
		let l:taskMsg = len(l:tasks) ==# 1 ? '(1 task)' : '(' . len(l:tasks) . ' tasks)'
		echohl Title | echo '"'. g:gv_default_gulpfile . '" ' . l:taskMsg . ':' | echohl None
	endif
	return join(l:tasks, "\n")
endfunction
function! gulpVim#Call(funcRef, action, ...) abort " {{{1
	" Automate the vim command creation:
	"	- Check if gulpfile is readable
	"	- Echo or execute depending of a:action

	let l:args = exists('a:000') ? a:000 : []
	if gulpVim#GulpFile(g:gv_default_gulpfile)
		if a:action ==# 'e'
			echo call(a:funcRef, l:args)
		else
			execute call(a:funcRef, l:args)
			execute 'redraw!'
		endif
	else
		echohl Error | echo 'No valid gulpfile in the current directory' | echohl None
	endif
endfunction
" }}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
