" Minimal pager-focused Neovim init for foot scrollback
" ================================================
set packpath+=~/.config/foot/scrollback-pager/nvim

" ===== Buffer settings =====
set relativenumber           " show line numbers
set noswapfile               " no swapfile for performance
set nobackup                 " no backup file
" *CLAUDE CHANGE* setting buftype=nofile at startup blocks the cmdline file
" from being read (see `:h 'buftype'`). Apply it after the buffer is loaded.
"set buftype=nofile           " buffer is not tied to a file
"set bufhidden=wipe           " wipe buffer on close
augroup scrollback_pager_buftype
  autocmd!
  autocmd BufReadPost * setlocal buftype=nofile bufhidden=wipe
augroup END
set number                   " show absolute line number

" ===== UI enhancements =====
set termguicolors            " enable true color support
set laststatus=0             " hide status line
set background=dark          " dark background
colorscheme desert           " simple colorscheme
set list                     " show whitespace

" ===== Navigation & search =====
set scrolloff=8              " keep context when scrolling
set ignorecase               " case-insensitive search

" ===== Interaction =====
set mouse=a                  " enable mouse support
set clipboard+=unnamedplus   " use system clipboard
set virtualedit=all          " allow cursor past end of line

" ===== Performance tweak =====
set lazyredraw               " speed up redraws during macros

" ===== Quick quit =====
nnoremap <silent> q :qa!<CR>   " quit all

" ===== Highlight on yank =====
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.hl').on_yank({timeout = 40})
augroup END

" ===== Prevent insert mode in terminal buffers =====
augroup prevent_insert
  autocmd!
  autocmd TermEnter * stopinsert
augroup END

lua << EOF
-- *CLAUDE CHANGE* pcall so missing plugin doesn't abort the rest of init.vim.
local ok, ya = pcall(require, "YankAssassin")
if ok then
  ya.setup { auto_normal = true, auto_visual = true }
end
EOF
