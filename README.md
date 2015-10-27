Gulp-vim
========

[![GitHub version](https://badge.fury.io/gh/kabbamine%2Fgulp-vim.svg)](https://badge.fury.io/gh/kabbamine%2Fgulp-vim)

Description
-----------

This plugin is a simple [gulp](http://gulpjs.com) wrapper for vim
*(Works on GNU/Linux and Windows)*

Installation
-----------

Use your preferred method to install the plugin, anyway I recommend you to use a plugin manager.

e.g with [Vim-plug](https://github.com/junegunn/vim-plug)

```
Plug 'KabbAmine/gulp-vim'
```

This is not mandatory, but the plugin can use [Tpope's Dispatch plugin](https://github.com/tpope/vim-dispatch) if its installed.

So to install the plugin again with Vim-plug using lazyloading and group dependencies functionalities.

```
Plug 'KabbAmine/gulp-vim', {'on': ['Gulp', 'GulpExt', 'GulpFile', 'GulpTasks']}
			\| Plug 'tpope/vim-dispatch'
```

Usage
---------

### Main commands

Gulp-vim provides 2 main commands: `Gulp` and `GulpExt`.

Both commands accept 0 or many arguments (Task name(s)), that can be [completed](#completion) using `<Tab>` (If no task name was provided, *'default'* is used).

```
:Gulp    [task(s)...]
:GulpExt [task(s)...]
```


The difference between those 2 commands is that `Gulp` executes gulp inside Vim and `GulpExt` open an external terminal (The default one via `exo-open` in GNU/Linux and a simple `cmd` in Windows) or use [Dispatch](#dispatch), then execute gulp.

**Don't use gulp watching tasks with the command `Gulp` (`<Ctrl-C>` to stop it), use `GulpExt` instead**.

### Misc

```
:GulpTasks
```

Shows a list of your gulp task names (Extracted from the current `gulpfile`).

```
:GulpFile [gulpfile]
```

Define the `gulpfile` to use, e.g. `gulpfile.js`, `gulpfile.coffee`, `gulpfile.babel.js` (Set it to `gulpfile.js` when used without argument).

In fact, this command just assign a value to `g:gv_default_gulpfile`.

---------------------------


Configuration
---------

### Rvm hack

If you're using [rvm](https://rvm.io/) in GNU/Linux when using `GulpExt` and opening a new terminal window, rvm shell functions will not be exported so your gems and some gulp plugins will not work (`gulp-compass` as an example).

To get rid of that add to your vimrc:

```
let g:gv_rvm_hack = 1
```

### Go back to the shell prompt

By default with `GulpExt`, when the gulp task is completed, the terminal is closed.
If you want to go back to the shell prompt after executing the task, add to your vimrc:

```
let g:gv_return_2_prompt = 1
```

**P.S:** Only works when `g:gv_use_dispatch = 0`

### Specify the gulpfile

You can specify the gulpfile to use with `g:gv_default_gulpfile` variable (By default, it's `gulpfile.js`).

e.g.
```
let g:gv_default_gulpfile = 'gulpfile.coffee'
" Or
let g:gv_default_gulpfile = 'gulpfile.babel.js'
```

### Use dispatch <a id="dispatch"></a>

By default if the plugin Dispatch is installed, the command `GulpExt` will use `Start!` to execute Gulp, this means:

* In Linux: If you're in tmux, a new window will be created otherwise the default terminal will be open.
* In Windows: A minimized cmd.exe window is spawned.

You can disable this integration by setting `g:gv_use_dispatch` to `0`

```
let g:gv_use_dispatch = 0
```

Extra
------

### Completion <a id="completion"></a>

Gulp-vim searches for a *gulpfile* (`g:gv_default_gulpfile`) in the current vim directory (`:pwd`) then extract from it task names to provide command completion (This method is quicker than using `gulp --tasks-simple`).

TODO
-----

- [x] Add doc file.
- [x] Support other gulpfile(s):
  - [x] gulpfile.coffee
  - [x] gulpfile.babel.js
- [ ] Possibility to define custom terminal if needed (?)
- [x] Integrate [Dispatch](https://github.com/tpope/vim-dispatch "Dispatch plugin url") or a similar plugin to avoid [#1](https://github.com/KabbAmine/gulp-vim/issues/1) (?)

NOTES
-----

Thanks to gulp author(s).

Thanks to Bram Moolenaar for creating the best piece of software in the world :D

Thanks to you if you're using gulp-vim.
