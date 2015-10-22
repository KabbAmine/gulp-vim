Gulp-vim
========

Description
-----------

This plugin is a simple [gulp](http://gulpjs.com) wrapper for vim
*(Works on GNU/Linux and Windows)*

Installation
-----------

### Manually

Install the distributed files into Vim runtime directory which is usually `~/.vim/`, or `$HOME/vimfiles` on Windows.

### Using a plugin manager

And this is the recommended way, use a vim plugin manager:

| Plugin manager                                         | In vimrc                         | Installation command |
|--------------------------------------------------------|----------------------------------|----------------------|
| [Vim-plug](https://github.com/junegunn/vim-plug)       | `Plug 'KabbAmine/gulp-vim'`      | `PlugInstall`          |
| [Vundle](https://github.com/gmarik/Vundle.vim)         | `Plugin 'KabbAmine/gulp-vim'`    | `PluginInstall`        |
| [NeoBundle](https://github.com/Shougo/neobundle.vim)   | `NeoBundle 'KabbAmine/gulp-vim'` | `NeoBundleInstall`     |

Usage
---------

### Main commands

Gulp-vim provides 2 main commands: `Gulp` and `GulpExt`.

Both commands accept 0 or many arguments (Task name(s)), that can be [completed](#completion) using `<Tab>` (If no task name was provided, *'default'* is used).

```
:Gulp    [task(s)...]
:GulpExt [task(s)...]
```


The difference between those 2 commands is that `Gulp` executes gulp inside Vim and `GulpExt` open an external terminal (The default one via `exo-open` in GNU/Linux and a simple `cmd` in Windows) then execute gulp.

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

### Specify the gulpfile

You can specify the gulpfile to use with `g:gv_default_gulpfile` variable (By default, it's `gulpfile.js`).

e.g.
```
let g:gv_default_gulpfile = 'gulpfile.coffee'
" Or
let g:gv_default_gulpfile = 'gulpfile.babel.js'
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
- [ ] Integrate [Dispatch](https://github.com/tpope/vim-dispatch "Dispatch plugin url") or a similar plugin to avoid [#1](https://github.com/KabbAmine/gulp-vim/issues/1) (?)

NOTES
-----

Thanks to gulp author(s).

Thanks to Bram Moolenaar for creating the best piece of software in the world :D

Thanks to you if you're using gulp-vim.
