function! s:configureKeymaps(plugin_in) abort
  if a:plugin_in == "vim-unimpaired"
    function! s:ArgNext(...)
      try
        let l:files = ""
        for file in a:000
          let l:files .= file .. " "
        endfor
        execute "next" l:files
        args
      catch /^Vim\%((\a\+)\)\=:E163:/
        first
        args
      catch /^Vim\%((\a\+)\)\=:E165:/
        first
        args
      finally
      endtry
    endfunction

    function! s:ArgPrev(...)
      try
        previous
        args
      catch /^Vim\%((\a\+)\)\=:E163:/
        last
        args
      catch /^Vim\%((\a\+)\)\=:E164:/
        last
        args
      finally
      endtry
    endfunction

    command -nargs=* Anext call <SID>ArgNext(<f-args>)
    command Aprev call <SID>ArgPrev(<f-args>)


    nnoremap ]a <Cmd>Anext<cr>
    nnoremap [a <Cmd>Aprev<cr>


    cnoreabbrev <expr> next  getcmdtype() == ":" && getcmdline() == "next" ? "Anext" : "next"
    cnoreabbrev <expr> n  getcmdtype() == ":" && getcmdline() == "n" ? "Anext" : "n"
    cnoreabbrev <expr> prev  getcmdtype() == ":" && getcmdline() == "prev" ? "Aprev" : "prev"
    cnoreabbrev <expr> previous  getcmdtype() == ":" && getcmdline() == "prevous" ? "Aprev" : "previous"
  elseif a:plugin_in == "blue"
  elseif a:plugin_in == "vimted"

    map <leader>st :call Synctex()<cr>
    map <leader>lv :VimtexView<cr>
    colorscheme blue
  elseif a:plugin_in == "vim-yankstack"
    nmap <C-p> <Plug>yankstack_substitute_older_paste
    nmap <C-n> <Plug>yankstack_substitute_newer_paste
  elseif a:plugin_in == "vim-bbye"

    cnoreabbrev <expr> bd  getcmdtype() == ":" && getcmdline() == "bd" ? "Bdelete" : "bd"
    cnoreabbrev <expr> bw  getcmdtype() == ":" && getcmdline() == "bw" ? "Bwipeout" : "bw"
    cnoreabbrev <expr> wbd  getcmdtype() == ":" && getcmdline() == "wbd" ? "w \| Bdelete" : "bd"
    cnoreabbrev <expr> wbw  getcmdtype() == ":" && getcmdline() == "wbw" ? "w \| Bwipeout" : "bw"
  else
    echo "plugin " .. a:plugin_in .. " not found"
  endif
endfunction

command -bar -nargs=1 ConfigureKeymaps call s:configureKeymaps(<q-args>)
