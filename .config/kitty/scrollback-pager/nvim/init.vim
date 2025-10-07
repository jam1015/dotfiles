" Minimal pager-focused Neovim init for Kitty scrollback
" ================================================
set packpath+=~/.config/kitty/scrollback-pager/nvim

" ===== Buffer settings =====
set relativenumber           " show line numbers
set noswapfile               " no swapfile for performance
set nobackup                 " no backup file
set buftype=nofile           " buffer is not tied to a file
set bufhidden=wipe           " wipe buffer on close
set number                   " show absolute line number

" ===== UI enhancements =====n
set termguicolors            " enable true color support
set laststatus=0             " hide status line
set background=dark          " dark background
colorscheme desert           " simple colorscheme
set list                     " show whitespace

" ===== Navigation & search =====
set scrolloff=8              " keep context when scrolling
set ignorecase               " case-insensitive search

" ===== Interaction =====n
set mouse=a                  " enable mouse support
set clipboard+=unnamedplus   " use system clipboard
set virtualedit=all          " allow cursor past end of line

" ===== Performance tweak =====n
set lazyredraw               " speed up redraws during macros

" ===== Quick quit =====n
nnoremap <silent> q :qa!<CR>   " quit all

" ===== Highlight on yank =====n
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

        require("YankAssassin").setup {
            auto_normal = true, -- if true, autocmds are used. Whenever y is used in normal mode, the cursor doesn't move to start
            auto_visual = true, -- if true, autocmds are used. Whenever y is used in visual mode, the cursor doesn't move to start
        }

EOF


" ===== Start at bottom on open =====
"function! Scrollback_StartAtBottom()
"  " Jump to the last line and end of that line
"  normal! G$
"  " Search backwards for the first non-blank character and move to its end
"
"let has_text = (getline('.') =~# '\S') >= 0
"if has_text
"endif
"
"  call search('\S', 'bWec')
"  " Clear any search highlighting
"  nohlsearch
"  colorscheme blue
"endfunction
"
"augroup start_at_bottom
"  autocmd!
"  " Run on startup and when buffer window opens, scheduling to ensure content loaded
"  autocmd WinEnter,VimEnter,BufReadPost,BufWinEnter * call Scrollback_StartAtBottom()
""  autocmd VimEnter * ++nested call timer_start(0, { -> Scrollback_StartAtBottom() })
""  autocmd BufWinEnter * ++nested if &buftype ==# 'nofile' | call timer_start(0, { -> Scrollback_StartAtBottom() }) | endif
"augroup END
