-- see ~/.config/nvim/lua/keymaps/init.lua for other plugins
-- function that returns keymaps based on name of plugin supplied

local has_wk, wk = pcall(require, "which-key")
if has_wk then
	local wk_opts = {
		mode = "n", -- NORMAL mode
		-- prefix: use "<leader>f" for example for mapping everything related to finding files
		-- the prefix is prepended to every mapping part of `mappings`
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
		expr = false, -- use `expr` when creating keymaps
	}
end
M = {}
function M.pluginKeymaps(plugin, setup_type)
	local keymap = vim.keymap.set
	local opts = { remap = false, silent = true }


	if plugin == "vim_create_goto" then
		vim.keymap.set('n', '<leader>fc', '<Plug>(CreateGoTo)', { remap = true })
	elseif plugin == "cscope_maps" then
		local get_cscope_prompt_cmd = function(operation, selection)
			local sel = "cword"   -- word under cursor
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
			g = "Find this global defination",
			c = "Find functions calling this function",
			t = "Find this text string",
			e = "Find this egrep pattern",
			f = "Find this file",
			i = "Find files #including this file",
			d = "Find functions called by this function",
			a = "Find places where this symbol is assigned a value",
			b = "Build database",
		}
		keymap("n", "<leader>cs", get_cscope_prompt_cmd("s", "w"), { noremap = true, silent = true, desc = sym_map.s })
		keymap("n", "<leader>cg", get_cscope_prompt_cmd("g", "w"), { noremap = true, silent = true, desc = sym_map.g })
		keymap("n", "<leader>cc", get_cscope_prompt_cmd("c", "w"), { noremap = true, silent = true, desc = sym_map.c })
		keymap("n", "<leader>ct", get_cscope_prompt_cmd("t", "w"), { noremap = true, silent = true, desc = sym_map.t })
		keymap("n", "<leader>ce", get_cscope_prompt_cmd("e", "w"), { noremap = true, silent = true, desc = sym_map.e })
		keymap("n", "<leader>cf", get_cscope_prompt_cmd("f", "f"), { noremap = true, silent = true, desc = sym_map.f })
		keymap("n", "<leader>ci", get_cscope_prompt_cmd("i", "f"), { noremap = true, silent = true, desc = sym_map.i })
		keymap("n", "<leader>cd", get_cscope_prompt_cmd("d", "w"), { noremap = true, silent = true, desc = sym_map.d })
		keymap("n", "<leader>ca", get_cscope_prompt_cmd("a", "w"), { noremap = true, silent = true, desc = sym_map.a })
		keymap("n", "<leader>cb", "<Cmd>Cscope build<cr>", { noremap = true, silent = true, desc = sym_map.b })
	elseif plugin == "vim-rooter" then
		keymap("n", "<leader>rf", ":cd <c-r>=FindRootDirectory()<CR>", { remap = true, silent = false })
	elseif plugin == "yanky.nvim" then
		vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
		vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
		vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
		vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")
		vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")
		vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")

		local has_tele, telescope = pcall(require, "telescope")
		if has_tele then
			telescope.load_extension("yank_history")
			--		vim.api.nvim_create_user_command("YankyRingHistory",
			--			function() require("telescope").extensions.yank_history.yank_history(require('telescope.themes').get_ivy()) end,
			--			{})

			keymap("n", "<leader>yr", "<Cmd>Telescope yank_history<cr>", opts)
		end
	elseif plugin == "emmet-vim" then
	elseif plugin == "hop" then
		vim.cmd([[
			onoremap <leader>ww :HopWord<CR>
			nnoremap <leader>ww :HopWord<CR>
			]])
	elseif plugin == "telescope" then
		local builtin = require('telescope.builtin')
		--		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		--		vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
		--		vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
		--		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
		--
		--		keymap("n", "<leader>th",
		--			"<Cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>",
		--			opts)
		--		keymap("n", "<leader>tf",
		--			"<Cmd>lua require('telescope.builtin').find_files({hidden = false})<CR>", opts)
		--		keymap("v", "<leader>ts", builtin.grep_string, opts)
		--		keymap("n", "<leader>bb", builtin.buffers, opts)
		--		keymap("n", "<leader>tg", builtin.live_grep, opts)
		--		keymap("n", "<leader>ts", builtin.grep_string, opts)

		wk.register({
			["<leader>t"] = { name = "+telescope/terminals" },
			["<leader>tf"] = { "<Cmd>lua require('telescope.builtin').find_files({hidden = true}) <cr>", "Find Files" },
			["<leader>th"] = { "<Cmd>lua require('telescope.builtin').find_files({hidden = false}) <cr>",
				"Find Hidden Files" },
			["<leader>tg"] = { "<Cmd>lua require('telescope.builtin').live_grep() <cr>", "Live Grep" },
			["<leader>ts"] = { "<Cmd>lua require('telescope.builtin').grep_string() <cr>", "Grep String" },
			["<leader>tb"] = { "<Cmd>lua require('telescope.builtin').buffers() <cr>", "Buffers" },
		})
		wk.register({
			["<leader>ts"] = { "<Cmd>lua require('telescope.builtin').grep_string() <cr>", "Grep String" },
		}, { mode = "v" })
	elseif plugin == "mason" then
		return {
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
	elseif plugin == "PushPop.vim" then
		vim.cmd([[
			cnoreabbrev <expr> pud  getcmdtype() == ":" && getcmdline() == "pud" ? "Pushd" : "pud"
			cnoreabbrev <expr> pod  getcmdtype() == ":" && getcmdline() == "pod" ? "Popd" : "pod"
			cnoreabbrev <expr> dirs  getcmdtype() == ":" && getcmdline() == "dirs" ? "Dirs" : "dirs"
			]])
	else
		error("plugin " .. plugin .. " not found\n")
	end
end

function M.vim_yankstack()
	vim.cmd([[
			nmap <C-p> <Plug>yankstack_substitute_older_paste
			nmap <C-n> <Plug>yankstack_substitute_newer_paste
			]])
end

function M.emmet_vim(setup_type)
	if setup_type == "config" then
		wk.register({ ["<leader>m"] = { name = "emmet" } })
		vim.cmd([[
					nmap <leader>m,   <plug>(emmet-expand-abbr)
					nmap <leader>m;   <plug>(emmet-expand-word)
					nmap <leader>mu   <plug>(emmet-update-tag)
					nmap <leader>md   <plug>(emmet-balance-tag-inward)
					nmap <leader>mD   <plug>(emmet-balance-tag-outward)
					nmap <leader>mn   <plug>(emmet-move-next)
					nmap <leader>mN   <plug>(emmet-move-prev)
					nmap <leader>mi   <plug>(emmet-image-size)
					nmap <leader>m/   <plug>(emmet-toggle-comment)
					nmap <leader>mj   <plug>(emmet-split-join-tag)
					nmap <leader>mk   <plug>(emmet-remove-tag)
					nmap <leader>ma   <plug>(emmet-anchorize-url)
					nmap <leader>mA   <plug>(emmet-anchorize-summary)
					nmap <leader>mm   <plug>(emmet-merge-lines)
					nmap <leader>mc   <plug>(emmet-code-pretty)
					]])
	elseif setup_type == "init" then
		vim.g.user_emmet_leader_key = "<C-B>" --use this followed by comma to expand emmet
	else
	end
end

function M.nvim_treehopper()
	wk.register({
		["<leader>h"] = { name = "Hopping" },
		["<leader>ht"] = { "<cmd>lua require('tsht').move({ side = 'start' })<cr>", "Treehopper Move" },
	})

	wk.register({
		["<leader>h"] = { name = "Hopping" },
		["<leader>ht"] = { ":<C-U>lua require('tsht').nodes()<cr>", "Treehopper Move" },
	}, { mode = "o", noremap = false }) -- 'o' for operator-pending mode

	wk.register({
		["<leader>h"] = { name = "Hopping" },
		["<leader>ht"] = { "<cmd>lua require('tsht').nodes()<cr>", "Treehopper Move" },
	}, { mode = "x" }) -- 'x' for visual mode
end

function M.leap_ast()
	wk.register({
		["<leader>h"] = { name = "Hopping" },
		["<leader>ht"] = {function() require'leap-ast'.leap() end, "leap-ast move" },
	})

	wk.register({
		["<leader>h"] = { name = "Hopping" },
		["<leader>ht"] = {function() require'leap-ast'.leap() end, "leap-ast move" },
	}, { mode = "o", noremap = false }) -- 'o' for operator-pending mode

	wk.register({
		["<leader>h"] = { name = "Hopping" },
		["<leader>ht"] = {function() require'leap-ast'.leap() end, "leap-ast move" },
	}, { mode = "x" }) -- 'x' for visual mode
end

function M.vim_unimpaired()
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
					
					
					nnoremap ]a <Cmd>Anext<cr>
					nnoremap [a <Cmd>Aprev<cr>
					
					cnoreabbrev <expr> next  getcmdtype() == ":" && getcmdline() == "next" ? "Anext" : "next"
					cnoreabbrev <expr> n  getcmdtype() == ":" && getcmdline() == "n" ? "Anext" : "n"
					cnoreabbrev <expr> prev  getcmdtype() == ":" && getcmdline() == "prev" ? "Aprev" : "prev"
					cnoreabbrev <expr> previous  getcmdtype() == ":" && getcmdline() == "prevous" ? "Aprev" : "previous"

			]])
end

function M.vim_slime()
	vim.keymap.set("n", "gz", "<Plug>SlimeMotionSend", { remap = true, silent = false })
	vim.keymap.set("n", "gzz", "<Plug>SlimeLineSend", { remap = true, silent = false })
	vim.keymap.set("x", "gz", "<Plug>SlimeRegionSend", { remap = true, silent = false })
	vim.keymap.set("n", "gzc", "<Plug>SlimeConfig", { remap = true, silent = false })
end

function M.nvim_cmp()
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
	vim.keymap.set('n', '<leader>uu', vim.cmd.UndotreeToggle)
end

function M.substitute_nvim()
	wk.register({
		["<leader>xc"] = { require('substitute.exchange').operator, "Exchange operator", noremap = true },
		["<leader>xx"] = { require('substitute.exchange').line, "Exchange line", noremap = true },
		["<leader>xq"] = { require('substitute.exchange').cancel, "Cancel exchange", noremap = true },
	}, { mode = "n" }) -- 'n' for normal mode

	wk.register({
		["<leader>X"] = { require('substitute.exchange').visual, "Exchange in visual mode", noremap = true },
	}, { mode = "x" }) -- 'x' for visual mode
end

function M.nvim_smart_termsplit()
	local termsplit = require('nvim-smart-termsplit')

	wk.register({
		["<C-a>s"] = { termsplit.term_hsplit, "Split Term Horizontally", mode = "n", noremap = true, silent = true },
		["<C-a>v"] = { termsplit.term_vsplit, "Split Term Vertically", mode = "n", noremap = true, silent = true },
	})

	wk.register({
		["<C-a>s"] = { termsplit.term_hsplit, "Split Term Horizontally", mode = "t", noremap = true, silent = true },
		["<C-a>v"] = { termsplit.term_vsplit, "Split Term Vertically", mode = "t", noremap = true, silent = true },
	})
end

function M.nvim_tree()
	vim.keymap.set("n", "<leader>nt", "<Cmd>NvimTreeToggle<CR>", { remap = false, silent = true })
end

function M.nvim_window()
	--vim.keymap.set("n","<C-a>g", "<cmd>lua require('nvim-window').pick()<cr>", { remap = false, silent = true })
	wk.register({
		["<C-w>g"] = { require('nvim-window').pick, "Select window by label", noremap = true },
	}, { mode = "n" }) -- 'n' for normal mode
end

function M.nvim_winshift()
	--vim.keymap.del('n', '<C-w>x')
	wk.register({
		["<C-w>x"] = { "<cmd>WinShift swap<CR>", "Exchange operator", noremap = true },
	}, { mode = "n" }) -- 'n' for normal mode
end

function M.bufdelete()
	vim.cmd([[
			cnoreabbrev <expr> bd  getcmdtype() == ":" && getcmdline() == "bd" ? "Bdelete" : "bd"
			cnoreabbrev <expr> bw  getcmdtype() == ":" && getcmdline() == "bw" ? "Bwipeout" : "bw"
			cnoreabbrev <expr> wbd  getcmdtype() == ":" && getcmdline() == "wbd" ? "w \| Bdelete" : "bd"
			cnoreabbrev <expr> wbw  getcmdtype() == ":" && getcmdline() == "wbw" ? "w \| Bwipeout" : "bw"
			]])
end

return M
