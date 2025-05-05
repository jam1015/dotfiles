			vim.cmd([[
  let g:vimtex_view_method = 'zathura'
  let g:vimtex_view_general_viewer = 'zathura'
  let g:vimtex_view_enabled=1
  let g:vimtex_complete_enabled=1

    let g:vimtex_compiler_latexmk = {
        \ 'aux_dir' : 'aux',
        \ 'build_dir' : 'build',
        \ 'out_dir' : 'out',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \}

let g:vimtex_compiler_bib = 'biber'
 	]])



