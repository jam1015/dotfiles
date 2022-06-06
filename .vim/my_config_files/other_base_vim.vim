
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

set history=2000		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

"if has('reltime')
  set incsearch
"endif
"
if has('win32')
  set guioptions-=t
endif
"
if &t_Co > 2 || has("gui_running")
"  " Revert with ":syntax off".
syntax on
"
  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif
"
if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif
