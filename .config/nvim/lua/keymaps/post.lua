local ok, wk = pcall(require, 'which-key')
if not ok then
	vim.notify("whic-key not installed", vim.log.levels.ERROR)
else
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

	wk.register({
		["<leader>tt"] = { "<cmd>terminal<cr>", "Open Terminal" },
		["<leader>tv"] = { "<C-w>v<cmd>terminal<cr>", "Open Terminal Vsplit" },
		["<leader>tl"] = { "<C-w>s<cmd>terminal<cr>", "Open Terminal Hsplit" }
	})
	wk.register({ ["<leader>ll"] = { "<cmd>nohlsearch<CR>", "nohighlight" }, ["<leader>l"] = { name = "aesthetics" } })
end
