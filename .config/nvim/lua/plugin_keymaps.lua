-- see ~/.config/nvim/lua/keymaps/init.lua for other plugins
-- function that returns keymaps based on name of plugin supplied

M = {}

function M.harpoon(harpoon)
  vim.keymap.set("n", "<leader>ah", function() harpoon:list():add() end, { desc = "harpoon add" })
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end

function M.hereterm()
  local wk = require("which-key")
  wk.add(
    {
      { "<C-;>", "<cmd>lua require('here-term').toggle_terminal()<CR>", desc = "here.term toggle", mode = "n" },
      { "<C-;>", "<cmd>lua require('here-term').toggle_terminal()<CR>", desc = "here.term toggle", mode = "t" },
      --{"<C-;>","<cmd>lua require('here-term').kill_terminal()<CR>", desc = "here.term kill" }
    }
  )
end

function M.vimtex()
  local wk = require("which-key")
  wk.add({
    { "<localleader>l", group = "vimtex", mode = "n" },
  }
  )
end

function M.glance()
  local wk = require("which-key")
  vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>')
  vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>')
  vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>')
  vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>')
end

function M.nvim_gui_termquit()
  local wk = require("which-key")
  wk.add({
    { "<localleader>tt", "<Plug>GotoTerminal", desc = "Select previous entry through yank history", mode = "n", remap = false },
  })
end

function M.hop()
  local wk = require("which-key")
  wk.add({
    { "<leader>ww", "<cmd>HopWord<CR>", desc = "Hop Word",  mode = "o", silent = true },
    { "<leader>ww", "<cmd>HopWord<CR>", desc = "Hop Word",  mode = "n", silent = true } })
end



function M.mason()
    return {
			-- Keymap to expand a package
			toggle_package_expand = "<CR>",
			-- Keymap to install the package under the current cursor position
			install_package = "i",
			-- Keymap to reinstall/update the package under the current cursor position
			update_package = "u",
			-- Keymap to check for new version for the package under the current cursor position
			check_package_version = "c",
			-- Keymap to update all installed packages
			update_all_packages = "U",
			-- Keymap to check which installed packages are outdated
			check_outdated_packages = "C",
			-- Keymap to uninstall a package
			uninstall_package = "X",
			-- Keymap to cancel a package installation
			cancel_installation = "<C-c>",
			-- Keymap to apply language filter
			apply_language_filter = "<C-f>",
    }
end


function M.pluginKeymaps(plugin, setup_type)
  local wk = require("which-key")
  local keymap = vim.keymap.set
  local opts = { remap = false, silent = true }


  if plugin == "mason" then
  else
    error("plugin " .. plugin .. " not found\n")
  end
end

function M.snipe_lsp()
  local wk = require("which-key")
  return {
    {
      vim.keymap.set('n', "<leader>ss", "<cmd>SnipeLspSymbols<CR>", { desc = 'Navigate LSP Symbols' }),
      vim.keymap.set('n', "<leader>sh", "<cmd>SnipeLspSymbolsSplit<CR>",
        { desc = 'Navigate LSP Symbols and open in a split pane' }),
      vim.keymap.set('n', "<leader>sv", "<cmd>SnipeLspSymbolsVSplit<CR>",
        { desc = 'Navigate LSP Symbols and open in a vertical split pane' })
    }
  }
end

function M.oil()
  local wk = require("which-key")
  vim.keymap.set("n", "<leader>oo", ":Oil", { remap = false, silent = true })
end

function M.yanky()
  local wk = require("which-key")
  wk.add({
    { "<leader>pp", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Open Yank History" },
    { "y",          "<Plug>(YankyYank)",                                                          mode = { "n", "x" },                                desc = "Yank text" },
    { "p",          "<Plug>(YankyPutAfter)",                                                      mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
    { "P",          "<Plug>(YankyPutBefore)",                                                     mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
    { "gp",         "<Plug>(YankyGPutAfter)",                                                     mode = { "n", "x" },                                desc = "Put yanked text after selection" },
    { "gP",         "<Plug>(YankyGPutBefore)",                                                    mode = { "n", "x" },                                desc = "Put yanked text before selection" },
    { "<c-p>",      "<Plug>(YankyPreviousEntry)",                                                 desc = "Select previous entry through yank history" },
    { "<c-n>",      "<Plug>(YankyNextEntry)",                                                     desc = "Select next entry through yank history" },
    --{ "]p",        "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = "Put indented after cursor (linewise)" },
    --{ "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = "Put indented before cursor (linewise)" },
    --{ "]P",        "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = "Put indented after cursor (linewise)" },
    --{ "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = "Put indented before cursor (linewise)" },
    --{ ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",                                      desc = "Put and indent right" },
    --{ "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",                                       desc = "Put and indent left" },
    --{ ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)",                                     desc = "Put before and indent right" },
    --{ "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",                                      desc = "Put before and indent left" },
    --{ "=p",        "<Plug>(YankyPutAfterFilter)",                                                desc = "Put after applying a filter" },
    --{ "=P",        "<Plug>(YankyPutBeforeFilter)",                                               desc = "Put before applying a filter" },
  }, { mode = "n", silent = true })
end

function M.yankstack()
  local wk = require("which-key")
  wk.add({
    { "<c-p>", "<Plug>yankstack_substitute_older_paste", desc = "Select previous entry through yank history" },
    { "<c-n>", "<Plug>yankstack_substitute_newer_paste", desc = "Select next entry through yank history" },
  })
end

function M.emmet_vim(setup_type)
  local wk = require("which-key")
  if setup_type == "config" then
    wk.add({
      { "<leader>m,", "<plug>(emmet-expand-abbr)",         desc = "Emmet expand abbreviation" },
      { "<leader>m;", "<plug>(emmet-expand-word)",         desc = "Emmet expand word" },
      { "<leader>mu", "<plug>(emmet-update-tag)",          desc = "Emmet update tag" },
      { "<leader>md", "<plug>(emmet-balance-tag-inward)",  desc = "Emmet balance tag inward" },
      { "<leader>mD", "<plug>(emmet-balance-tag-outward)", desc = "Emmet balance tag outward" },
      { "<leader>mn", "<plug>(emmet-move-next)",           desc = "Emmet move next" },
      { "<leader>mN", "<plug>(emmet-move-prev)",           desc = "Emmet move previous" },
      { "<leader>mi", "<plug>(emmet-image-size)",          desc = "Emmet image size" },
      { "<leader>m/", "<plug>(emmet-toggle-comment)",      desc = "Emmet toggle comment" },
      { "<leader>mj", "<plug>(emmet-split-join-tag)",      desc = "Emmet split join tag" },
      { "<leader>mk", "<plug>(emmet-remove-tag)",          desc = "Emmet remove tag" },
      { "<leader>ma", "<plug>(emmet-anchorize-url)",       desc = "Emmet anchorize url" },
      { "<leader>mA", "<plug>(emmet-anchorize-summary)",   desc = "Emmet anchorize summary" },
      { "<leader>mm", "<plug>(emmet-merge-lines)",         desc = "Emmet merge lines" },
      { "<leader>mc", "<plug>(emmet-code-pretty)",         desc = "Emmet code pretty" },
    }, { mode = "n", silent = true })
  elseif setup_type == "init" then
    vim.g.user_emmet_leader_key = "<C-B>" --use this followed by comma to expand emmet
  else
  end
end

function M.nvim_treehopper()
  local wk = require("which-key")
  wk.add({
    { "<leader>h",  name = "Hopping" },
    { "<leader>ht", "<cmd>lua require('tsht').move({ side = 'start' })<cr>", desc = "Treehopper Move" },
  }, { mode = "n", silent = true })

  wk.add({
    { "<leader>ht", ":<C-U>lua require('tsht').nodes()<cr>", desc = "Treehopper Nodes" },
  }, { mode = "o", silent = true }) -- 'o' for operator-pending mode

  wk.add({
    { "<leader>ht", "<cmd>lua require('tsht').nodes()<cr>", desc = "Treehopper Nodes" },
  }, { mode = "x", silent = true }) -- 'x' for visual mode
end

function M.leap_ast()
  local wk = require("which-key")
  wk.add({
    { "<leader>h",  name = "Hopping" },
    { "<leader>ht", function() require 'leap-ast'.leap() end, desc = "Leap AST Move" },
  }, { mode = { "n", "o", "x" }, silent = true }) -- Registering for normal, operator-pending, and visual modes
end

function M.unimpaired()
  local wk = require("which-key")
  vim.cmd([[
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
					
					
					cnoreabbrev <expr> next  getcmdtype() == ":" && getcmdline() == "next" ? "Anext" : "next"
					cnoreabbrev <expr> n  getcmdtype() == ":" && getcmdline() == "n" ? "Anext" : "n"
					cnoreabbrev <expr> prev  getcmdtype() == ":" && getcmdline() == "prev" ? "Aprev" : "prev"
					cnoreabbrev <expr> previous  getcmdtype() == ":" && getcmdline() == "prevous" ? "Aprev" : "previous"
			]])


  wk.add({
    { "]a", "<Cmd>Anext<cr>", desc = "Arg Next" },
    { "[a", "<Cmd>Aprev<cr>", desc = "Arg Prev" },
  }, { mode = "n", silent = true })
end

function M.vim_slime()
  local wk = require("which-key")
  wk.add({
    { "gz",  "<Plug>SlimeMotionSend", desc = "Slime Motion Send" },
    { "gzz", "<Plug>SlimeLineSend",   desc = "Slime Line Send" },
    mode = "n",
    silent = false,
    remap = true
  })

  wk.add({
    { "gz", "<Plug>SlimeRegionSend", desc = "Slime Region Send", mode = "x" },
    mode = "x",
    silent = false,
    remap = true
  })
end

function M.nvim_cmp()
  local wk = require("which-key")
  local function cmp_disable()
    require('cmp').setup.buffer { enabled = false }
  end

  local function cmp_enable()
    require('cmp').setup.buffer { enabled = true }
  end
  vim.api.nvim_create_user_command('CmpEnable', cmp_enable, { bar = true })
  vim.api.nvim_create_user_command('CmpDisable', cmp_disable, { bar = true })
end

function M.undotree()
  local wk = require("which-key")
  wk.add({
    { '<leader>uu', vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
  }, { mode = "n", silent = true })
end

function M.substitute_nvim()
  local wk = require("which-key")
  wk.add({
    { "<leader>xc", require('substitute.exchange').operator, desc = "Exchange operator" },
    { "<leader>xx", require('substitute.exchange').line,     desc = "Exchange line" },
    { "<leader>xq", require('substitute.exchange').cancel,   desc = "Cancel exchange" },
  }, { mode = "n", silent = true })
end

function M.nvim_smart_termsplit()
  local wk = require("which-key")
  local termsplit = require('nvim-smart-termsplit')
  wk.add({
    { "<C-w>s", termsplit.term_hsplit, desc = "Split Term Horizontally" },
    { "<C-w>v", termsplit.term_vsplit, desc = "Split Term Vertically" },
  }, { mode = "n", silent = true })
end

function M.nvim_tree()
  local wk = require("which-key")
  wk.add({
    { "<leader>nt", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle Nvim Tree" },
  }, { mode = "n", silent = true })
end

function M.nvim_window()
  local wk = require("which-key")
  wk.add({
    { "<C-w>g", require('nvim-window').pick, desc = "Select window by label" },
  }, { mode = "n", silent = true })
end

function M.nvim_winshift()
  local wk = require("which-key")
  wk.add({
    { "<C-w>x", "<cmd>WinShift swap<CR>", desc = "WinShift Swap" },
  }, { mode = "n", silent = true })
end

function M.bufdelete()
  local wk = require("which-key")
  vim.cmd([[
cnoreabbrev <expr> bd getcmdtype() == ":" && getcmdline() == "bd" ? "Bdelete" : "bd"
cnoreabbrev <expr> bw getcmdtype() == ":" && getcmdline() == "bw" ? "Bwipeout" : "bw"
cnoreabbrev <expr> wbd getcmdtype() == ":" && getcmdline() == "wbd" ? "w \| Bdelete" : "wbd"
cnoreabbrev <expr> wbw getcmdtype() == ":" && getcmdline() == "wbw" ? "w \| Bwipeout" : "wbw"
]])
end

function M.vim_create_goto()
  local wk = require("which-key")
  wk.add({
    { '<leader>fc', '<Plug>(CreateGoTo)', desc = "Create Goto" },
  }, { mode = "n", silent = false })
end

function M.cscope_maps()
  local wk = require("which-key")
  local keymap = vim.keymap.set
  local get_cscope_prompt_cmd = function(operation, selection)
    local sel = "cword"      -- word under cursor
    if selection == "f" then -- file under cursor
      sel = "cfile"
    end

    return string.format(
      [[<Cmd>lua require('cscope_maps').cscope_prompt('%s', vim.fn.expand("<%s>"))<cr>]],
      operation,
      sel
    )
  end
  local sym_map = {
    s = "Find this symbol",
    g = "Find this global definition",
    c = "Find functions calling this function",
    t = "Find this text string",
    e = "Find this egrep pattern",
    f = "Find this file",
    i = "Find files #including this file",
    d = "Find functions called by this function",
    a = "Find places where this symbol is assigned a value",
    b = "Build database",
  }
  wk.add({
    { "<leader>cs", get_cscope_prompt_cmd("s", "w"), desc = sym_map.s },
    { "<leader>cg", get_cscope_prompt_cmd("g", "w"), desc = sym_map.g },
    { "<leader>cc", get_cscope_prompt_cmd("c", "w"), desc = sym_map.c },
    { "<leader>ct", get_cscope_prompt_cmd("t", "w"), desc = sym_map.t },
    { "<leader>ce", get_cscope_prompt_cmd("e", "w"), desc = sym_map.e },
    { "<leader>cf", get_cscope_prompt_cmd("f", "f"), desc = sym_map.f },
    { "<leader>ci", get_cscope_prompt_cmd("i", "f"), desc = sym_map.i },
    { "<leader>cd", get_cscope_prompt_cmd("d", "w"), desc = sym_map.d },
    { "<leader>ca", get_cscope_prompt_cmd("a", "w"), desc = sym_map.a },
    { "<leader>cb", "<Cmd>Cscope build<cr>",         desc = sym_map.b },
  }, { mode = "n", silent = true })
end

function M.fzfx()
  local wk = require("which-key")
  wk.add({
    { "<leader>f",   group = "files-flash" },
    { "<leader>fs",  "<cmd>FzfxFiles<cr>",              desc = "Find files" },
    { "<leader>fw",  "<cmd>FzfxFiles cword<cr>",        desc = "Find files by cursor word" },
    { "<leader>fp",  "<cmd>FzfxFiles put<cr>",          desc = "Find files by yank text" },
    { "<leader>fr",  "<cmd>FzfxFiles resume<cr>",       desc = "Find files by resume last" },

    { "<leader>f",   group = "live grep" },
    { "<leader>lg",  "<cmd>FzfxLiveGrep<cr>",           desc = "Live grep" },
    { "<leader>lw",  "<cmd>FzfxLiveGrep cword<cr>",     desc = "Live grep by cursor word" },
    { "<leader>lp",  "<cmd>FzfxLiveGrep put<cr>",       desc = "Live grep by yank text" },
    { "<leader>lr",  "<cmd>FzfxLiveGrep resume<cr>",    desc = "Live grep by resume last" },

    --{ "<leader>bb", "<cmd>FzfxBuffers<cr>", desc = "Find buffers" },
    { "<leader>gf",  "<cmd>FzfxGFiles<cr>",             desc = "Find git files" },

    { "<leader>gl",  group = "git live grep" },
    { "<leader>gll", "<cmd>FzfxGLiveGrep<cr>",          desc = "Git live grep" },
    { "<leader>glw", "<cmd>FzfxGLiveGrep cword<cr>",    desc = "Git live grep by cursor word" },
    { "<leader>glp", "<cmd>FzfxGLiveGrep put<cr>",      desc = "Git live grep by yank text" },
    { "<leader>glr", "<cmd>FzfxGLiveGrep resume<cr>",   desc = "Git live grep by resume last" },

    { "<leader>gs",  "<cmd>FzfxGStatus<cr>",            desc = "Find git changed files (status)" },
    { "<leader>br",  "<cmd>FzfxGBranches<cr>",          desc = "Search git branches" },
    { "<leader>gc",  "<cmd>FzfxGCommits<cr>",           desc = "Search git commits" },
    { "<leader>gb",  "<cmd>FzfxGBlame<cr>",             desc = "Search git blame" },
    { "<leader>dg",  "<cmd>FzfxLspDiagnostics<cr>",     desc = "Search lsp diagnostics" },
    { "<leader>gd",  "<cmd>FzfxLspDefinitions<cr>",     desc = "Goto lsp definitions" },
    { "<leader>gt",  "<cmd>FzfxLspTypeDefinitions<cr>", desc = "Goto lsp type definitions" },
    { "<leader>gr",  "<cmd>FzfxLspReferences<cr>",      desc = "Goto lsp references" },
    { "<leader>gi",  "<cmd>FzfxLspImplementations<cr>", desc = "Goto lsp implementations" },
    { "<leader>gI",  "<cmd>FzfxLspIncomingCalls<cr>",   desc = "Goto lsp incoming calls" },
    { "<leader>gO",  "<cmd>FzfxLspOutgoingCalls<cr>",   desc = "Goto lsp outgoing calls" },
    { "<leader>cm",  "<cmd>FzfxCommands<cr>",           desc = "Search vim commands" },
    { "<leader>km",  "<cmd>FzfxKeyMaps<cr>",            desc = "Search vim keymaps" },
    { "<leader>mk",  "<cmd>FzfxMarks<cr>",              desc = "Search vim marks" },
    { "<leader>xp",  "<cmd>FzfxFileExplorer<cr>",       desc = "File explorer" },
  })



  -- Register visual select bindings
  wk.add({
    { "<leader>f",  group = "files-flash",           mode = "x" },                         -- for visual select
    { "<leader>fs", "<cmd>fzfxfiles visual<cr>",     desc = "Find files",    mode = "x" }, -- for visual select
    { "<leader>fg", "<cmd>fzfxglivegrep visual<cr>", desc = "Git live grep", mode = "x" }, -- for visual select
    { "<leader>fl", "<cmd>FzfxLiveGrep visual<cr>",  desc = "Live grep",     mode = "x" }, -- for visual select
  })
end

function M.flash_keys()
  local wk = require("which-key")
  return {
    --{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    --{ "<leader>ft", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    --{ "r",          mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --{ "<leader>fr", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --{ "<c-s>",      mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  }
end

function M.flash()
  return {

    { "s",          mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "r",          mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --    -- Treesitter & Treesitter-Search in all relevant modes
    { "<leader>xt", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "<leader>xr", mode = { "n", "x", "o" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
  }
end

function M.leap()
  local wk = require("which-key")
  wk.add({
    { 's',  '<Plug>(leap-forward)',     desc = "Leap Forward" },
    { 'S',  '<Plug>(leap-backward)',    desc = "Leap Backward" },
    { 'gs', '<Plug>(leap-from-window)', desc = "Leap From Window" },
  }, { mode = { 'n', 'x', 'o' }, silent = true })
end

function M.bufjump()
  local wk = require("which-key")
  wk.add({
    { "<leader>[b", "<cmd>lua require('bufjump').backward()<cr>", desc = "Jump Back Buffer" },
    { "<leader>]b", "<cmd>lua require('bufjump').forward()<cr>",  desc = "Jump Forward Buffer" },
  })
end

function M.telescope()
  local wk = require("which-key")
  local builtin = require('telescope.builtin')
  wk.add({
    { "<leader>fg", builtin.live_grep,                                     mode = "n", desc = "Live grep" },
    --{ "<leader>bb", builtin.buffers,                                       mode = "n", desc = "List buffers" },
    { "<leader>fh", builtin.help_tags,                                     mode = "n", desc = "Help tags" },
    { "<leader>th", function() builtin.find_files({ hidden = true }) end,  mode = "n", desc = "Find hidden files" },
    { "<leader>tf", function() builtin.find_files({ hidden = false }) end, mode = "n", desc = "Find files (no hidden)" },
    { "<leader>ts", function() builtin.grep_string({}) end,                mode = "n", desc = "Grep string" },
    { "<leader>tg", builtin.live_grep,                                     mode = "n", desc = "Live grep" },
    { "<leader>tb", builtin.buffers,                                       mode = "n", desc = "Buffers" },
  }, { silent = true })

  -- Visual mode bindings using new format
  wk.add({
    { "<leader>ts", builtin.grep_string, desc = "Grep string", mode = "x" },
  }, { silent = true })
end

function M.vim_rooter()
  local wk = require("which-key")
  wk.add({
    { "<leader>rf", ":cd <c-r>=FindRootDirectory()<CR>", desc = "Find Root Directory" },
  }, { mode = "n", silent = false })
end

function M.pushpop()
  local wk = require("which-key")
  vim.cmd([[
cnoreabbrev <expr> pud getcmdtype() == ":" && getcmdline() == "pud" ? "Pushd" : "pud"
cnoreabbrev <expr> pod getcmdtype() == ":" && getcmdline() == "pod" ? "Popd" : "pod"
cnoreabbrev <expr> dirs getcmdtype() == ":" && getcmdline() == "dirs" ? "Dirs" : "dirs"
]])
end

function M.gx()
  local wk = require("which-key")
  wk.add({
    { 'gx', "<cmd>Browse<cr>", desc = "Browse URL" },
  }, { mode = { 'n', 'x' }, silent = false })
end

function M.snipe()
  local wk = require("which-key")
  wk.add({ "<leader>bb", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu", mode = "n" })
end

function M.treewalker()
  local wk = require("which-key")
  -- Movement keymaps for normal and visual modes
  wk.add({
    { "<C-k>", "<cmd>Treewalker Up<cr>",    desc = "Treewalker Up" },
    { "<C-j>", "<cmd>Treewalker Down<cr>",  desc = "Treewalker Down" },
    { "<C-h>", "<cmd>Treewalker Left<cr>",  desc = "Treewalker Left" },
    { "<C-l>", "<cmd>Treewalker Right<cr>", desc = "Treewalker Right" },
  }, { mode = { "n", "v" }, silent = true })

  -- Swapping keymaps for normal mode
  wk.add({
    { "<leader>wk", "<cmd>Treewalker SwapUp<cr>",    desc = "Swap Up" },
    { "<leader>wj", "<cmd>Treewalker SwapDown<cr>",  desc = "Swap Down" },
    { "<leader>wh", "<cmd>Treewalker SwapLeft<cr>",  desc = "Swap Left" },
    { "<leader>wl", "<cmd>Treewalker SwapRight<cr>", desc = "Swap Right" },
  }, { mode = "n", silent = true })
end

return M
