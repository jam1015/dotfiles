require("plugin_keymaps").vim_slime()
if vim.g.slime_target == "tmux" then
  vim.cmd([[
  function! SlimeOverrideConfig()
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
  endfunction
  ]])
end
