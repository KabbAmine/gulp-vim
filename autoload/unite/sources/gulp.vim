" Unite source for gulp-vim based on `GulpTasks` command

let s:save_cpo = &cpo
set cpo&vim

let s:gulp_cmd = g:gv_unite_cmd

" source
let s:gulp_unite_source = {
	\ 'name': 'gulp',
	\ 'description': 'Available gulp tasks',
	\ 'hooks': {},
	\ 'action_table': {},
	\ 'default_action': {'common': 'execute'}
	\ }

function! s:getGulpTasks()
	let l:tasks = gulpVim#GetTasks()
	return !empty(l:tasks) ? split(l:tasks, "\n") : []
endfunction

" gather candidates
function! s:gulp_unite_source.gather_candidates(args, context)
	let gulpTasks = s:getGulpTasks()
	return map(gulpTasks, '{
		\ "word": v:val,
		\ "source": "gulp",
		\ "kind": "common"
		\ }')
endfunction

" action
let s:gulp_action_table = {}

let s:gulp_action_table.execute = {
	\ 'description': 'Run gulp task'
	\ }

function! s:gulp_action_table.execute.func(candidate)
	execute s:gulp_cmd . ' ' . a:candidate.word
endfunction

let s:gulp_unite_source.action_table.common = s:gulp_action_table

" define source
function! unite#sources#gulp#define()
	return s:gulp_unite_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
