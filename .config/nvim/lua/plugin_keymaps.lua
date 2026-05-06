-- see ~/.config/nvim/lua/keymaps/init.lua for other plugins
-- function that returns keymaps based on name of plugin supplied

-- =============================================================================
-- KEYMAP MIGRATION: Old → New
-- =============================================================================
-- harpoon:
--   <leader>ah → <leader>ha  (harpoon add)
--   <C-h> (slot 1) → <leader>h1   (freed <C-h> for treewalker)
--   <C-t> (slot 2) → <leader>h2
--   <C-n> (slot 3) → <leader>h3   (freed <C-n> for yanky)
--   <C-s> (slot 4) → <leader>h4
--   <C-S-P> (prev) → <leader>hp
--   <C-S-N> (next) → <leader>hn
--   <C-e> (menu)   → unchanged
--
-- hop:         <leader>ww       → <leader>jw       (jump word)
-- treehopper:  <leader>ht       → <leader>jt       (jump treesitter)
-- leap_ast:    <leader>ht       → <leader>jt
--
-- flash:
--   <leader>xt   → <leader>jt   (jump treesitter; freed x for exchange only)
--   <leader>xr   → <leader>jT   (jump treesitter search)
--
-- nvim_tree:   <leader>nt       → <leader>et       (explore tree; fixed conflict with neominimap)
-- oil:         <leader>oo       → <leader>eo       (explore oil; grouped with other explorers)
-- fzfx explorer: <leader>xp    → <leader>ex       → <leader>fze   (fzfx group)
--
-- neominimap:  <leader>n*       → <leader>m*       (minimap; whole group moved)
--   <leader>nm  → <leader>mm,  <leader>no  → <leader>mo,  <leader>nc  → <leader>mc
--   <leader>nr  → <leader>mr
--   <leader>nwt → <leader>mwt, <leader>nwr → <leader>mwr,
--   <leader>nwo → <leader>mwo, <leader>nwc → <leader>mwc
--   <leader>ntt → <leader>mtt, <leader>ntr → <leader>mtr,
--   <leader>nto → <leader>mto, <leader>ntc → <leader>mtc
--   <leader>nbt → <leader>mbt, <leader>nbr → <leader>mbr,
--   <leader>nbo → <leader>mbo, <leader>nbc → <leader>mbc
--   <leader>nf  → <leader>mf,  <leader>nu  → <leader>mu,  <leader>ns  → <leader>ms
--
-- emmet_vim:   <leader>m*       → <leader>em*      (emmet; freed m for minimap)
--
-- snipe_lsp (consolidated into lsp group):
--   <leader>ss  → <leader>ls    (lsp symbols)
--   <leader>sh  → <leader>lsh   (lsp symbols horizontal split)
--   <leader>sv  → <leader>lsv   (lsp symbols vertical split)
--
-- fzfx (all moved from scattered groups → <leader>fz):
--   files:      <leader>ff/<leader>fw/<leader>fp/<leader>fr → <leader>fzf/<leader>fzF (git files)
--   grep:       <leader>sg/<leader>sw/<leader>sp/<leader>sr → <leader>fzg/<leader>fzw
--   git:        <leader>gf → <leader>fzF, <leader>gs → <leader>fzs, <leader>gc → <leader>fzc
--               <leader>gb → <leader>fzb, <leader>gbr → <leader>fzB
--   git-grep:   <leader>glg → <leader>fzG  (variants dropped; use fzfx ui for word/yank)
--   lsp:        <leader>lx → <leader>fzx, <leader>ld → <leader>fzd, <leader>lt → <leader>fzt
--               <leader>lr → <leader>fzr, <leader>li → <leader>fzi
--               <leader>lI → <leader>fzI, <leader>lO → <leader>fzO
--   explore:    <leader>ex → <leader>fze
--   vim-meta:   <leader>vc → <leader>fzv, <leader>vk → <leader>fzk, <leader>vm → <leader>fzm
--   (groups <leader>g, <leader>s, <leader>v retired — all were fzfx-only)
--
-- treewalker:  <leader>w* → <leader><leader>w*  (swap group moved to double-leader)
-- telescope:   <leader>t* → <leader>te*  (freed <leader>t for tabs & terminals)
--   <leader>tH → <leader>teH, <leader>th → <leader>teh, <leader>tf → <leader>tef
--   <leader>ts → <leader>tes, <leader>tg → <leader>teg, <leader>tb → <leader>teb
--   <leader>tq → <leader>teq
-- hereterm:    <C-;> unchanged; <leader>tt added as alternate
-- nvim_smart_termsplit: <C-w>s/v/t unchanged; <leader>ts/<leader>tv/<leader>tT added
-- bufjump:
--   <leader>[b  → <leader>b[    (buffer history back)
--   <leader>]b  → <leader>b]    (buffer history forward)
-- =============================================================================

M = {}

function M.harpoon(harpoon)
	local wk = require("which-key")
	wk.add({
		{ "<leader>h", group = "harpoon" },
		{
			"<leader>ha",
			function()
				harpoon:list():add()
			end,
			desc = "Harpoon add",
		},
		{
			"<leader>hm",
			function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Harpoon menu",
		},
		{
			"<leader>h1",
			function()
				harpoon:list():select(1)
			end,
			desc = "Harpoon slot 1",
		},
		{
			"<leader>h2",
			function()
				harpoon:list():select(2)
			end,
			desc = "Harpoon slot 2",
		},
		{
			"<leader>h3",
			function()
				harpoon:list():select(3)
			end,
			desc = "Harpoon slot 3",
		},
		{
			"<leader>h4",
			function()
				harpoon:list():select(4)
			end,
			desc = "Harpoon slot 4",
		},
		{
			"<leader>hp",
			function()
				harpoon:list():prev()
			end,
			desc = "Harpoon prev",
		},
		{
			"<leader>hn",
			function()
				harpoon:list():next()
			end,
			desc = "Harpoon next",
		},
	}, { mode = "n", silent = true })
	vim.keymap.set("n", "<C-e>", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)
end

function M.hereterm()
	local wk = require("which-key")
	wk.add({
		{ "<C-;>", "<cmd>lua require('here-term').toggle_terminal()<CR>", desc = "here.term toggle", mode = "n" },
		{ "<C-;>", "<cmd>lua require('here-term').toggle_terminal()<CR>", desc = "here.term toggle", mode = "t" },
		{ "<leader>tt", "<cmd>lua require('here-term').toggle_terminal()<CR>", desc = "Terminal toggle", mode = "n" },
	})
end

function M.vimtex()
	local wk = require("which-key")
	wk.add({
		{ "<localleader>l", group = "vimtex", mode = "n" },
	})
end

function M.glance()
	vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
	vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
	vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
	vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")
end

function M.nvim_gui_termquit()
	local wk = require("which-key")
	wk.add({
		{ "<localleader>tt", "<Plug>GotoTerminal", desc = "Go to terminal", mode = "n", remap = false },
	})
end

function M.hop()
	local wk = require("which-key")
	wk.add({
		{ "<leader>j", group = "jump" },
		{ "<leader>jw", "<cmd>HopWord<CR>", desc = "Hop word", mode = "o", silent = true },
		{ "<leader>jw", "<cmd>HopWord<CR>", desc = "Hop word", mode = "n", silent = true },
	})
end

function M.mason()
	return {
		toggle_package_expand = "<CR>",
		install_package = "i",
		update_package = "u",
		check_package_version = "c",
		update_all_packages = "U",
		check_outdated_packages = "C",
		uninstall_package = "X",
		cancel_installation = "<C-c>",
		apply_language_filter = "<C-f>",
	}
end

function M.neominimap()
	-- Global
	local wk = require("which-key")
	wk.add({
		{ "<leader>m", group = "minimap" },
		{ "<leader>mm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle minimap" },
		{ "<leader>mo", "<cmd>Neominimap Enable<cr>", desc = "Enable minimap" },
		{ "<leader>mc", "<cmd>Neominimap Disable<cr>", desc = "Disable minimap" },
		{ "<leader>mr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh minimap" },
		-- Window-specific
		{ "<leader>mw", group = "minimap-window" },
		{ "<leader>mwt", "<cmd>Neominimap WinToggle<cr>", desc = "Window minimap toggle" },
		{ "<leader>mwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Window minimap refresh" },
		{ "<leader>mwo", "<cmd>Neominimap WinEnable<cr>", desc = "Window minimap enable" },
		{ "<leader>mwc", "<cmd>Neominimap WinDisable<cr>", desc = "Window minimap disable" },
		-- Tab-specific
		{ "<leader>mt", group = "minimap-tab" },
		{ "<leader>mtt", "<cmd>Neominimap TabToggle<cr>", desc = "Tab minimap toggle" },
		{ "<leader>mtr", "<cmd>Neominimap TabRefresh<cr>", desc = "Tab minimap refresh" },
		{ "<leader>mto", "<cmd>Neominimap TabEnable<cr>", desc = "Tab minimap enable" },
		{ "<leader>mtc", "<cmd>Neominimap TabDisable<cr>", desc = "Tab minimap disable" },
		-- Buffer-specific
		{ "<leader>mb", group = "minimap-buffer" },
		{ "<leader>mbt", "<cmd>Neominimap BufToggle<cr>", desc = "Buffer minimap toggle" },
		{ "<leader>mbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Buffer minimap refresh" },
		{ "<leader>mbo", "<cmd>Neominimap BufEnable<cr>", desc = "Buffer minimap enable" },
		{ "<leader>mbc", "<cmd>Neominimap BufDisable<cr>", desc = "Buffer minimap disable" },
		-- Focus
		{ "<leader>mf", "<cmd>Neominimap Focus<cr>", desc = "Minimap focus" },
		{ "<leader>mu", "<cmd>Neominimap Unfocus<cr>", desc = "Minimap unfocus" },
		{ "<leader>ms", "<cmd>Neominimap ToggleFocus<cr>", desc = "Minimap toggle focus" },
	}, { mode = "n" })
end

function M.pluginKeymaps(plugin, setup_type)
	if plugin == "mason" then
	else
		error("plugin " .. plugin .. " not found\n")
	end
end

function M.snipe_lsp()
	local wk = require("which-key")
	wk.add({
		{ "<leader>l", group = "lsp" },
		{ "<leader>ls", "<cmd>SnipeLspSymbols<CR>", desc = "LSP symbols" },
		{ "<leader>lsh", "<cmd>SnipeLspSymbolsSplit<CR>", desc = "LSP symbols (h-split)" },
		{ "<leader>lsv", "<cmd>SnipeLspSymbolsVSplit<CR>", desc = "LSP symbols (v-split)" },
	}, { mode = "n" })
end

function M.oil()
	local wk = require("which-key")
	wk.add({
		{ "<leader>e", group = "explore" },
		{ "<leader>eo", "<cmd>Oil<CR>", desc = "Oil explorer" },
	}, { mode = "n", silent = true })
end

function M.yanky()
	local wk = require("which-key")
	wk.add({
		{ "<leader>p", group = "paste" },
		{
			"<leader>pp",
			function()
				require("telescope").extensions.yank_history.yank_history({})
			end,
			desc = "Yank history",
		},
		{
			"y",
			"<Plug>(YankyYank)",
			mode = { "n", "x" },
			desc = "Yank text",
		},
		{
			"p",
			"<Plug>(YankyPutAfter)",
			mode = { "n", "x" },
			desc = "Put after cursor",
		},
		{
			"P",
			"<Plug>(YankyPutBefore)",
			mode = { "n", "x" },
			desc = "Put before cursor",
		},
		{
			"gp",
			"<Plug>(YankyGPutAfter)",
			mode = { "n", "x" },
			desc = "Put after selection",
		},
		{
			"gP",
			"<Plug>(YankyGPutBefore)",
			mode = { "n", "x" },
			desc = "Put before selection",
		},
		{
			"<c-p>",
			"<Plug>(YankyPreviousEntry)",
			desc = "Yank history prev",
		},
		{
			"<c-n>",
			"<Plug>(YankyNextEntry)",
			desc = "Yank history next",
		},
	}, { mode = "n", silent = true })
end

function M.yankstack()
	local wk = require("which-key")
	wk.add({
		{ "<c-p>", "<Plug>yankstack_substitute_older_paste", desc = "Yank history prev" },
		{ "<c-n>", "<Plug>yankstack_substitute_newer_paste", desc = "Yank history next" },
	})
end

function M.emmet_vim(setup_type)
	local wk = require("which-key")
	if setup_type == "config" then
		wk.add({
			{ "<leader>em", group = "emmet" },
			{ "<leader>em,", "<plug>(emmet-expand-abbr)", desc = "Expand abbreviation" },
			{ "<leader>em;", "<plug>(emmet-expand-word)", desc = "Expand word" },
			{ "<leader>emu", "<plug>(emmet-update-tag)", desc = "Update tag" },
			{ "<leader>emd", "<plug>(emmet-balance-tag-inward)", desc = "Balance tag inward" },
			{ "<leader>emD", "<plug>(emmet-balance-tag-outward)", desc = "Balance tag outward" },
			{ "<leader>emn", "<plug>(emmet-move-next)", desc = "Move next" },
			{ "<leader>emN", "<plug>(emmet-move-prev)", desc = "Move previous" },
			{ "<leader>emi", "<plug>(emmet-image-size)", desc = "Image size" },
			{ "<leader>em/", "<plug>(emmet-toggle-comment)", desc = "Toggle comment" },
			{ "<leader>emj", "<plug>(emmet-split-join-tag)", desc = "Split/join tag" },
			{ "<leader>emk", "<plug>(emmet-remove-tag)", desc = "Remove tag" },
			{ "<leader>ema", "<plug>(emmet-anchorize-url)", desc = "Anchorize URL" },
			{ "<leader>emA", "<plug>(emmet-anchorize-summary)", desc = "Anchorize summary" },
			{ "<leader>emm", "<plug>(emmet-merge-lines)", desc = "Merge lines" },
			{ "<leader>emc", "<plug>(emmet-code-pretty)", desc = "Code pretty" },
		}, { mode = "n", silent = true })
	elseif setup_type == "init" then
		vim.g.user_emmet_leader_key = "<C-B>"
	end
end

function M.nvim_treehopper()
	local wk = require("which-key")
	wk.add({
		{ "<leader>j", group = "jump" },
		{ "<leader>jt", "<cmd>lua require('tsht').move({ side = 'start' })<cr>", desc = "Treehopper move" },
	}, { mode = "n", silent = true })

	wk.add({
		{ "<leader>jt", ":<C-U>lua require('tsht').nodes()<cr>", desc = "Treehopper nodes" },
	}, { mode = "o", silent = true })

	wk.add({
		{ "<leader>jt", "<cmd>lua require('tsht').nodes()<cr>", desc = "Treehopper nodes" },
	}, { mode = "x", silent = true })
end

function M.leap_ast()
	local wk = require("which-key")
	wk.add({
		{ "<leader>j", group = "jump" },
		{
			"<leader>jt",
			function()
				require("leap-ast").leap()
			end,
			desc = "Leap AST",
		},
	}, { mode = { "n", "o", "x" }, silent = true })
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

    cnoreabbrev <expr> next     getcmdtype() == ":" && getcmdline() == "next"     ? "Anext" : "next"
    cnoreabbrev <expr> n        getcmdtype() == ":" && getcmdline() == "n"        ? "Anext" : "n"
    cnoreabbrev <expr> prev     getcmdtype() == ":" && getcmdline() == "prev"     ? "Aprev" : "prev"
    cnoreabbrev <expr> previous getcmdtype() == ":" && getcmdline() == "previous" ? "Aprev" : "previous"
  ]])

	wk.add({
		{ "]a", "<Cmd>Anext<cr>", desc = "Arg next" },
		{ "[a", "<Cmd>Aprev<cr>", desc = "Arg prev" },
	}, { mode = "n", silent = true })
end

function M.vim_slime()
	local wk = require("which-key")
	wk.add({
		{ "gz", "<Plug>SlimeMotionSend", desc = "Slime send motion" },
		{ "gzz", "<Plug>SlimeLineSend", desc = "Slime send line" },
		mode = "n",
		silent = false,
		remap = true,
	})
	wk.add({
		{ "gz", "<Plug>SlimeRegionSend", desc = "Slime send region", mode = "x" },
		mode = "x",
		silent = false,
		remap = true,
	})
end

function M.nvim_cmp()
	local function cmp_disable()
		require("cmp").setup.buffer({ enabled = false })
	end
	local function cmp_enable()
		require("cmp").setup.buffer({ enabled = true })
	end
	vim.api.nvim_create_user_command("CmpEnable", cmp_enable, { bar = true })
	vim.api.nvim_create_user_command("CmpDisable", cmp_disable, { bar = true })
end

function M.undotree()
	local wk = require("which-key")
	wk.add({
		{ "<leader>u", group = "undotree" },
		{ "<leader>uu", vim.cmd.UndotreeToggle, desc = "Toggle undotree" },
	}, { mode = "n", silent = true })
end

function M.substitute_nvim()
	local wk = require("which-key")
	wk.add({
		{ "<leader>x", group = "exchange" },
		{ "<leader>xc", require("substitute.exchange").operator, desc = "Exchange operator" },
		{ "<leader>xx", require("substitute.exchange").line, desc = "Exchange line" },
		{ "<leader>xq", require("substitute.exchange").cancel, desc = "Cancel exchange" },
	}, { mode = "n", silent = true })
end

function M.nvim_smart_termsplit()
	local wk = require("which-key")
	local termsplit = require("nvim-smart-termsplit")
	wk.add({
		{ "<C-w>s", termsplit.term_hsplit, desc = "Term split horizontal" },
		{ "<C-w>v", termsplit.term_vsplit, desc = "Term split vertical" },
		{ "<C-w>t", termsplit.term_tabnew, desc = "Term in new tab" },
		{ "<leader>t", group = "tabs & terminals & telescope" },
		{ "<leader>ts", termsplit.term_hsplit, desc = "Terminal hsplit" },
		{ "<leader>tv", termsplit.term_vsplit, desc = "Terminal vsplit" },
		{ "<leader>tt", termsplit.term_tabnew, desc = "Terminal new tab" },
	}, { mode = "n", silent = true })
	wk.add({
		{ "<C-w><S-s>", "<C-w>s", desc = "Split horizontal" },
		{ "<C-w><S-v>", "<C-w>v", desc = "Split vertical" },
	}, { mode = "n", silent = true, remap = false })
end

function M.nvim_tree()
	local wk = require("which-key")
	wk.add({
		{ "<leader>e", group = "explore" },
		{ "<leader>et", "<Cmd>NvimTreeToggle<CR>", desc = "Nvim tree toggle" },
	}, { mode = "n", silent = true })
end

function M.nvim_window()
	local wk = require("which-key")
	wk.add({
		{ "<C-w>g", require("nvim-window").pick, desc = "Pick window" },
	}, { mode = "n", silent = true })
end

function M.nvim_winshift()
	local wk = require("which-key")
	wk.add({
		{ "<C-w>x", "<cmd>WinShift swap<CR>", desc = "WinShift swap" },
	}, { mode = "n", silent = true })
end

function M.bufdelete()
	vim.cmd([[
    cnoreabbrev <expr> bd  getcmdtype() == ":" && getcmdline() == "bd"  ? "Bdelete"        : "bd"
    cnoreabbrev <expr> bw  getcmdtype() == ":" && getcmdline() == "bw"  ? "Bwipeout"       : "bw"
    cnoreabbrev <expr> wbd getcmdtype() == ":" && getcmdline() == "wbd" ? "w \| Bdelete"   : "wbd"
    cnoreabbrev <expr> wbw getcmdtype() == ":" && getcmdline() == "wbw" ? "w \| Bwipeout"  : "wbw"
  ]])
end

function M.vim_create_goto()
	local wk = require("which-key")
	wk.add({
		{ "<leader>f", group = "find" },
		{ "<leader>fc", "<Plug>(CreateGoTo)", desc = "Create goto" },
	}, { mode = "n", silent = false })
end

function M.cscope_maps()
	local wk = require("which-key")
	local get_cscope_prompt_cmd = function(operation, selection)
		local sel = "cword"
		if selection == "f" then
			sel = "cfile"
		end
		return string.format(
			[[<Cmd>lua require('cscope_maps').cscope_prompt('%s', vim.fn.expand("<%s>"))<cr>]],
			operation,
			sel
		)
	end
	wk.add({
		{ "<leader>c", group = "cscope" },
		{ "<leader>cs", get_cscope_prompt_cmd("s", "w"), desc = "Find symbol" },
		{ "<leader>cg", get_cscope_prompt_cmd("g", "w"), desc = "Find global definition" },
		{ "<leader>cc", get_cscope_prompt_cmd("c", "w"), desc = "Find callers" },
		{ "<leader>ct", get_cscope_prompt_cmd("t", "w"), desc = "Find text string" },
		{ "<leader>ce", get_cscope_prompt_cmd("e", "w"), desc = "Find egrep pattern" },
		{ "<leader>cf", get_cscope_prompt_cmd("f", "f"), desc = "Find file" },
		{ "<leader>ci", get_cscope_prompt_cmd("i", "f"), desc = "Find includers" },
		{ "<leader>cd", get_cscope_prompt_cmd("d", "w"), desc = "Find callees" },
		{ "<leader>ca", get_cscope_prompt_cmd("a", "w"), desc = "Find assignments" },
		{ "<leader>cb", "<Cmd>Cscope build<cr>", desc = "Build cscope db" },
	}, { mode = "n", silent = true })
end

function M.fzfx()
	local wk = require("which-key")
	wk.add({
		{ "<leader>fz", group = "fzfx" },
		-- Files
		{ "<leader>fzf", "<cmd>FzfxFiles<cr>", desc = "Files" },
		{ "<leader>fzw", "<cmd>FzfxFiles cword<cr>", desc = "Files by word" },
		{ "<leader>fzF", "<cmd>FzfxGFiles<cr>", desc = "Git files" },
		-- Grep / search
		{ "<leader>fzg", "<cmd>FzfxLiveGrep<cr>", desc = "Live grep" },
		{ "<leader>fzs", "<cmd>FzfxLiveGrep cword<cr>", desc = "Grep by word" },
		-- Git
		{ "<leader>fzb", "<cmd>FzfxGBlame<cr>", desc = "Git blame" },
		{ "<leader>fzS", "<cmd>FzfxGStatus<cr>", desc = "Git status" },
		{ "<leader>fzc", "<cmd>FzfxGCommits<cr>", desc = "Git commits" },
		{ "<leader>fzB", "<cmd>FzfxGBranches<cr>", desc = "Git branches" },
		{ "<leader>fzG", "<cmd>FzfxGLiveGrep<cr>", desc = "Git grep" },
		-- LSP
		{ "<leader>fzd", "<cmd>FzfxLspDefinitions<cr>", desc = "LSP definitions" },
		{ "<leader>fzt", "<cmd>FzfxLspTypeDefinitions<cr>", desc = "LSP type defs" },
		{ "<leader>fzr", "<cmd>FzfxLspReferences<cr>", desc = "LSP references" },
		{ "<leader>fzi", "<cmd>FzfxLspImplementations<cr>", desc = "LSP implementations" },
		{ "<leader>fzI", "<cmd>FzfxLspIncomingCalls<cr>", desc = "LSP incoming calls" },
		{ "<leader>fzO", "<cmd>FzfxLspOutgoingCalls<cr>", desc = "LSP outgoing calls" },
		{ "<leader>fzx", "<cmd>FzfxLspDiagnostics<cr>", desc = "LSP diagnostics" },
		-- Explore & vim meta
		{ "<leader>fze", "<cmd>FzfxFileExplorer<cr>", desc = "File explorer" },
		{ "<leader>fzm", "<cmd>FzfxMarks<cr>", desc = "Vim marks" },
		{ "<leader>fzk", "<cmd>FzfxKeyMaps<cr>", desc = "Vim keymaps" },
		{ "<leader>fzv", "<cmd>FzfxCommands<cr>", desc = "Vim commands" },
	})

	wk.add({
		{ "<leader>fzf", "<cmd>FzfxFiles visual<cr>", desc = "Files", mode = "x" },
		{ "<leader>fzg", "<cmd>FzfxLiveGrep visual<cr>", desc = "Live grep", mode = "x" },
		{ "<leader>fzG", "<cmd>FzfxGLiveGrep visual<cr>", desc = "Git grep", mode = "x" },
	})
end

function M.flash_keys()
	return {}
end

function M.flash()
	return {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash jump",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Flash remote",
		},
		{
			"<leader>jt",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash treesitter",
		},
		{
			"<leader>jT",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Flash treesitter search",
		},
	}
end

function M.leap()
	local wk = require("which-key")
	wk.add({
		{ "s", "<Plug>(leap-forward)", desc = "Leap forward" },
		{ "S", "<Plug>(leap-backward)", desc = "Leap backward" },
		{ "gs", "<Plug>(leap-from-window)", desc = "Leap from window" },
	}, { mode = { "n", "x", "o" }, silent = true })
end

function M.bufjump()
	local wk = require("which-key")
	wk.add({
		{ "<leader>b", group = "buffers" },
		{ "<leader>b[", "<cmd>lua require('bufjump').backward()<cr>", desc = "Buffer history back" },
		{ "<leader>b]", "<cmd>lua require('bufjump').forward()<cr>", desc = "Buffer history forward" },
	})
end

function M.telescope()
	local wk = require("which-key")
	local builtin = require("telescope.builtin")
	wk.add({
		{ "<leader>te", group = "telescope" },
		{ "<leader>teH", builtin.help_tags, mode = "n", desc = "Help tags" },
		{
			"<leader>teh",
			function()
				builtin.find_files({ hidden = true })
			end,
			mode = "n",
			desc = "Find hidden files",
		},
		{
			"<leader>tef",
			function()
				builtin.find_files({ hidden = false })
			end,
			mode = "n",
			desc = "Find files",
		},
		{
			"<leader>tes",
			function()
				builtin.grep_string({})
			end,
			mode = "n",
			desc = "Grep string",
		},
		{ "<leader>teg", builtin.live_grep, mode = "n", desc = "Live grep" },
		{ "<leader>teb", builtin.buffers, mode = "n", desc = "Buffers" },
		{ "<leader>teq", builtin.quickfix, mode = "n", desc = "Quickfix" },
	}, { silent = true })
	wk.add({
		{ "<leader>tes", builtin.grep_string, desc = "Grep string", mode = "x" },
	}, { silent = true })
end

function M.vim_rooter()
	local wk = require("which-key")
	wk.add({
		{ "<leader>r", group = "rooter" },
		{ "<leader>rf", ":cd <c-r>=FindRootDirectory()<CR>", desc = "CD to root" },
		{ "<leader>rd", "<cmd>cd %:p:h<cr>", desc = "CD to file dir" },
	}, { mode = "n", silent = false })
end

function M.pushpop()
	vim.cmd([[
    cnoreabbrev <expr> pud  getcmdtype() == ":" && getcmdline() == "pud"  ? "Pushd" : "pud"
    cnoreabbrev <expr> pod  getcmdtype() == ":" && getcmdline() == "pod"  ? "Popd"  : "pod"
    cnoreabbrev <expr> dirs getcmdtype() == ":" && getcmdline() == "dirs" ? "Dirs"  : "dirs"
  ]])
end

function M.gx()
	local wk = require("which-key")
	wk.add({
		{ "gx", "<cmd>Browse<cr>", desc = "Browse URL" },
	}, { mode = { "n", "x" }, silent = false })
end

function M.snipe()
	local wk = require("which-key")
	wk.add({
		{ "<leader>b", group = "buffers" },
		{
			"<leader>bb",
			function()
				require("snipe").open_buffer_menu()
			end,
			desc = "Buffer menu (snipe)",
			mode = "n",
		},
	})
end

function M.treewalker()
	local wk = require("which-key")
	wk.add({
		{ "<leader>w", group = "treewalker" },
		{ "<leader>w<c-k>", "<cmd>Treewalker Up<cr>", desc = "Treewalker up" },
		{ "<leader>w<c-j>", "<cmd>Treewalker Down<cr>", desc = "Treewalker down" },
		{ "<leader>w<c-h>", "<cmd>Treewalker Left<cr>", desc = "Treewalker left" },
		{ "<leader>w<c-l>", "<cmd>Treewalker Right<cr>", desc = "Treewalker right" },
	}, { mode = { "n", "v" }, silent = true })

	wk.add({
		{ "<leader>w", group = "treewalker" },
		{ "<leader>wk", "<cmd>Treewalker SwapUp<cr>", desc = "Swap up" },
		{ "<leader>wj", "<cmd>Treewalker SwapDown<cr>", desc = "Swap down" },
		{ "<leader>wh", "<cmd>Treewalker SwapLeft<cr>", desc = "Swap left" },
		{ "<leader>wl", "<cmd>Treewalker SwapRight<cr>", desc = "Swap right" },
	}, { mode = "n", silent = true })
end

return M
