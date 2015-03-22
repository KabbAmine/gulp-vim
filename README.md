Gulp-vim
========

Description
-----------

This plugin is a simple [gulp](http://gulpjs.com) wrapper for vim
*(Tested on GNU/Linux and Windows)*


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

Gulp-vim provides 2 main commands: `Gulp` and `GulpExt`.

Both commands accept 0 or many arguments (Task name(s)), that can be [completed](#completion) using `<Tab>`.

```
:Gulp    [task(s)...]
:GulpExt [task(s)...]
```

If no task name was provided, *'default'* is used.

The difference between those 2 commands is that `Gulp` executes gulp inside Vim and `GulpExt` open an external terminal (The default one via `exo-open` in Unix and a simple `cmd` in Windows) then execute gulp.

**Don't use gulp watching tasks with the command `Gulp` (In case, `<Ctrl-C>` to stop it), use `GulpExt` for those tasks**.

---------------------------

There is also a command that just shows a list of your gulp task names (Extracted from current `gulpfile.js`).

```
:GulpTasks
```

Extra
---------

### Rvm hack

If you're using [rvm](https://rvm.io/) in *unix*, when using `GulpExt` and opening a new terminal window, rvm shell functions will not be exported so your gems and some gulp plugins will not work (`gulp-compass` as an example).

To get rid of that add to your vimrc:

```
let g:gv_rvm_hack = 1
```

### Completion <a id="completion"></a>

Gulp-vim searches for a *gulpfile.js* in the current vim directory (`:pwd`) then extract from it task names to provide command completion (This method is quicker than using `gulp --tasks-simple`).

TODO
-----

- :white_medium_square: Possibility to define custom terminal.
- :white_medium_square: Support other gulpfile(s?) if needed (gulpfile.coffee?).

NOTES
-----

Thanks to gulp author(s).

Thanks to Bram Moolenaar for creating the best piece of software in the world :D

Thanks to you if you're using gulp-vim.
