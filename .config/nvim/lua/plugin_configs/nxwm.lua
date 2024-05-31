require('nxwm').setup({
  --What happens when a new x-window is created
  on_win_open = function(buf, xwin)
    vim.cmd.vsplit()
    vim.api.nvim_set_current_buf(buf)
  end,
  --Configuration to pass to window
  --`conf` is global config
  on_win_get_conf = function(conf, xwin) return conf end,
  --How to handle when multiple windows in the same tabpage has the x-window-buffer open
  on_multiple_win_open = function(vwins, buf, xwin)
    for k, vwin in ipairs(vwins) do
      if k ~= 1 then
        local scratchbuf = vim.api.nvim_create_buf(false, true)
        vim.bo[scratchbuf].bufhidden = 'wipe'
        vim.api.nvim_win_set_buf(vwin, scratchbuf)
      end
    end
  end,
  --Whether to be more verbose
  verbal = false,
  --Map to unfocus a window (multiple key mappings is not (yet) supported)
  unfocus_map = '<A-F4>',
  --Create your own mappings
  --IMPORTANT: the x-window needs to be focused for such mappings to work
  maps = {
    --{'<C-A-del>',function () vim.cmd'quitall!' end},
    --Or you could also have lhs as a table
    --{{mods={'control','mod1'},key='Delete'},function () vim.cmd'quitall!' end},
  },
  --Window-opt: auto focus x-window when entering x-window-buffer
  autofocus = false,
  --Window-opt: try-delete x-window if no vim-window shows buffer (similar to `bufhidden=wipe`)
  delhidden = true,
  --Window-opt: when click on x-window, goto that buffer (may not focus x-window)
  clickgoto = true,
  --Window-opt: offset the window this many x pixels (useful if terminal has padding)
  xoffset = 0,
  --Window-opt: offset the window this many y pixels (useful if terminal has padding)
  yoffset = 0,
})
