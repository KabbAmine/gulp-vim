if exists('g:loaded_ctrlp_gulp') && g:loaded_ctrlp_gulp
	finish
endif
let g:loaded_ctrlp_gulp = 1

let s:gulp_cmd = g:gv_ctrlp_cmd

let s:gulp_var = {
			\  'init':   'ctrlp#gulp#init()',
			\  'exit':   'ctrlp#gulp#exit()',
			\  'accept': 'ctrlp#gulp#accept',
			\  'lname':  'gulp',
			\  'sname':  'gulp',
			\  'type':   'gulp',
			\  'sort':   0,
			\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:gulp_var)
else
	let g:ctrlp_ext_vars = [s:gulp_var]
endif

function! ctrlp#gulp#init()
	return split(gulpVim#GetTasks(), "\n")
endfunc

function! ctrlp#gulp#accept(mode, str)
	call ctrlp#exit()
	execute s:gulp_cmd . ' ' . matchstr(a:str, '^\S\+\ze.*')
endfunction

function! ctrlp#gulp#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#gulp#id()
	return s:id
endfunction
