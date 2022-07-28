
"---------- setting other settings -----------
"
"to let vim have correct colors in tmux

"other colorscheme commands
highlight Comment cterm=italic

"Actually setting  the colorscheme ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set termguicolors

let g:tokyonight_style = "night"

if empty($DISPLAY)
  colorscheme elflord
else
  colorscheme tokyonight
endif

set hlsearch
"toggles relnum vs absnum



function! ToggleNumberToggle()
    if !exists('#numbertoggle#BufEnter')

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,CmdLineLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter  * set norelativenumber
	autocmd CmdLineEnter * set norelativenumber | redraw
augroup END

    else
        augroup numbertoggle
            autocmd!
        augroup END
    endif
endfunction

call ToggleNumberToggle()

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq
set number
set undofile "persistent undo

set undodir=~/.config/nvim/undodir "the folder where the undo history is kept rather than the local directory for the file
set gdefault
set nrformats-=octal
set autoindent
set scrolloff=3                 " show a few lines around cursor
"set synmaxcol=80
set display=truncate
"set smartindent
set shiftwidth=4 "how much indentation from >
set softtabstop=4 "lets us delete by tabs when expandtab is on
set tabstop=4
set noexpandtab
set nosmarttab
set nocindent
set nosmartindent
set wildmenu
set wildmode=full
"set cursorline
"set cursorcolumn
set list
set listchars=
set ignorecase
set smartcase
set listchars+=tab:··░

set listchars+=lead:·
		lua <<EOF
-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]]
EOF

set listchars+=trail:␣
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
let g:netrw_liststyle= 3


autocmd BufNewFile,BufRead *.md setlocal iskeyword+=#

"" some things for zathura+synctex
"let g:vimtex_compiler_method='tectonic'

"set spell spelllang=en_us
"hi clear SpellBad
"hi clear SpellLocal
"jset listchars+=space:·
" onoremap K -J
" always split windows vertically; need to learn vimscript to understand
"set splitright
"set splitbelow



"if exists('#vim_help') "formatting for vim help; show bars/asterisks
"	augroup! vim_help
"endif

"turns and helpbars and help stars
filetype plugin indent on
