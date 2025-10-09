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


local latex_textobjects = vim.api.nvim_create_augroup("LatexTextObjects", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = latex_textobjects,
  pattern = { "tex", "bib", "plaintex", "context" },
  callback = function()
    vim.keymap.set({'x', 'o'}, 'ad', '<Plug>(textobj-entire-a)', { buffer = true })
    vim.keymap.set({'x', 'o'}, 'id', '<Plug>(textobj-entire-i)', { buffer = true })
  end,
})
