" basic vimrc taken from https://dash9.dev/posts/nvim-1/
source ~/.config/nvim/my_config_files/premade.vim
if has('nvim')
else
source ~/.vim/my_config_files/other_base_vim.vim
endif "for having nvim
"---- personal virc----------------------
" defining cofmands based on minpac
packadd minpac
call minpac#init() "make sure that this is the first plugin initialized

if !exists('g:loaded_minpac')
	echo "minpac not available"
else  	" minpac is available.

		call minpac#add('k-takata/minpac', {'type': 'opt'}) "packadd does it well
source ~/.config/nvim/my_config_files/minpac_setup.vim

		source ~/.config/nvim/my_config_files/vim_colorschemes.vim
		source ~/.config/nvim/my_config_files/vim_plugins.vim

		if has('nvim')

source ~/.config/nvim/my_config_files/nvim_plugins.vim
source ~/.config/nvim/my_config_files/nvim_colorschemes.vim


		else "nvim packages
		endif

endif

"---custom keybindings go here--------
"add type these after a search to instantly move text
"move to text
"cnoremap $t <CR>:t''<CR>  
"move text to 
"cnoremap $m <CR>:m''<CR>
"delete
"cnoremap $d <CR>:d<CR>``

" makes count up and down motions actual lines if a number is given
"nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
"nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

"force visual motion     
nnoremap dj dvj
nnoremap dk dvk
nnoremap 0 ^
nnoremap ^ 0
"nnoremap $ g$
"nnoremap g$ $
"nnoremap 0 g0
"nnoremap g0 0
"nnoremap ^ g^
"nnoremap g^ ^

"---------- setting other settings -----------
"
"to let vim have correct colors in tmux
"set termguicolors

"other colorscheme commands
highlight Comment cterm=italic

"Actually setting  the colorscheme ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if has('nvim')
colorscheme nightfox
else
endif

set hlsearch
"toggles relnum vs absnum
augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave,CmdLineLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter  * set norelativenumber
autocmd CmdLineEnter * set norelativenumber | redraw
augroup END
" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq
set number
set undofile "persistent undo
if has('nvim')
set undodir=~/.config/nvim/undodir "the folder where the undo history is kept rather than the local directory for the file
else
set undodir=~/.vim/undodir
endif

set nrformats-=octal
set autoindent
set scrolloff=3                 " show a few lines around cursor
set display=truncate
"set smartindent
set shiftwidth=4 "how much indentation from >
set softtabstop=4 "lets us delete by tabs when expandtab is on
set tabstop=4
let g:python_recommended_style=0
set noexpandtab
set nosmarttab
set wildmenu
set wildmode=full
"set cursorline
"set cursorcolumn
set list
set listchars=
set ignorecase
set smartcase
set listchars+=tab:··░
if has('nvim')
set listchars+=lead:·
endif
set listchars+=trail:␣
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
"jset listchars+=space:·
" onoremap K -J
" always split windows vertically; need to learn vimscript to understand
"set splitright
"set splitbelow

"<leader>l means no highlighting anymore
nnoremap <silent> <leader>l :noh<CR>
"make * not move 
nmap <silent> <leader>* yiw<Esc>: let @/ = @"" <CR> :set hls <CR>

"remap omnicomplete
inoremap <C-j> <C-x><C-o>

filetype plugin indent on
if exists('#vim_help') "formatting for vim help; show bars/asterisks
	augroup! vim_help
endif

"turns and helpbars and help stars
augroup vim_help
	autocmd!
	autocmd FileType help setlocal conceallevel=0 "probably to show the stars and bars
	autocmd FileType help setlocal number
	autocmd FileType help hi link HelpBar Normal
	autocmd FileType help hi link HelpStar Normal
augroup END

"determine wher help appears
command -nargs=* -complete=help Lelp vertical topleft help <args>
command -nargs=* -complete=help Relp vertical belowright help <args>
command -nargs=* -complete=help Telp  topleft help <args>
command -nargs=* -complete=help Belp  belowright help <args>
"
" have to ask why cnoremap makes typing in command lines slow
cnoreabbrev <expr> lelp  getcmdtype() == ":" && getcmdline() == "lelp" ? "Lelp" : "lelp"
cnoreabbrev <expr> relp  getcmdtype() == ":" && getcmdline() == "relp" ? "Relp" : "relp"
cnoreabbrev <expr> telp  getcmdtype() == ":" && getcmdline() == "telp" ? "Telp" : "telp"
cnoreabbrev <expr> belp  getcmdtype() == ":" && getcmdline() == "belp" ? "Belp" : "belp"

"echo "init.vim sourced"
