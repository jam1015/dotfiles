require("plugin_keymaps").vim_slime()
  vim.cmd([[
  ]])

if vim.g.slime_target == "neovim" then
  vim.cmd([[

" delegation
function! s:SlimeDispatchValidate(name, ...)
  " using try catch because exists() doesn't detect autoload functions that aren't yet loaded
  " the idea is to return the interger 1 for true in cases where a target doesn't have
  " the called validation function implemented. E117 is 'Unknown function'.
  try
    return call ("s:SlimeDispatch", [a:name] + a:000)
  catch /^Vim\%((\a\+)\)\=:E117:/
    return 1
  endtry
endfunction

function! s:SlimeDispatch(name, ...)
  " allow custom override
  let override_fn = "SlimeOverride" . slime#common#capitalize(a:name)
  if exists("*" . override_fn)
    return call(override_fn, a:000)
  endif
  return call("slime#targets#" . slime#config#resolve("target") . "#" . a:name, a:000)
endfunction


function! SlimeOverrideConfig()
  if g:slime_target == "tmux"
    if !exists("b:slime_config")
      let b:slime_config = {"socket_name": "default", "target_pane": ""}
    endif
    let b:slime_config["socket_name"] = input("tmux socket name or absolute path: ", b:slime_config["socket_name"])

    let panes_list = split(slime#targets#tmux#pane_names("","",""), "\n")
    if match(panes_list[0], '^no server running') != 0
      if (exists("g:slime_menu_config") || exists("b:slime_menu_config")) && slime#config#resolve("menu_config")
        echo panes_list


        call insert(panes_list, ":")
        let menu_strings = copy(panes_list)
        for i in range(0, len(menu_strings) - 1)
          let menu_strings[i] = i . '. ' . menu_strings[i]
        endfor
        call insert(menu_strings, "Select a target tmux pane:")
        let selection = str2nr(inputlist(menu_strings))
        if selection < 0 || selection >= len(menu_strings)
          echohl WarningMsg
          echo "Selection out of bounds. Setting pane to \":\"."
          echohl None
          let b:slime_config["target_pane"] = ":"
          return
        endif
        let b:slime_config["target_pane"] = panes_list[selection]
      else
        let b:slime_config["target_pane"] = input("tmux target pane: ", b:slime_config["target_pane"], "custom,slime#targets#tmux#pane_names")
      endif
    else
      echohl WarningMsg
      echo("No server running")
      echohl None
    endif

    " processing pane string
    if b:slime_config["target_pane"] =~ '\s\+'
      let b:slime_config["target_pane"] = split(b:slime_config["target_pane"])[0]
    endif
  endif


  if g:slime_target == "neovim"
    if exists("b:slime_config")
      let old_config = b:slime_config
    endif

    call slime#targets#neovim#config()

    if exists("b:slime_config") && !s:SlimeDispatchValidate("ValidConfig", b:slime_config, 0)
      unlet b:slime_config
      if exists("old_config")
        echohl WarningMsg
        echo "--Restoring previous config.--"
        echohl None
        let b:slime_config = old_config
      endif
    endif

  endif



endfunction
  ]])
end
