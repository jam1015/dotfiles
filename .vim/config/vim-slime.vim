let g:slime_target = "tmux"
let g:slime_python_ipython = 0
let g:slime_no_mappings = 1
let g:slime_input_pid = 0
let g:slime_suggest_default = 1
let g:slime_menu_config = 0
let g:slime_bracketed_paste = 1

" Key mappings for vim-slime
nmap gz <Plug>SlimeMotionSend
nmap gzz <Plug>SlimeLineSend
xmap gz <Plug>SlimeRegionSend
