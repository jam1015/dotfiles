require("nvim-surround").setup({
	-- Configuration here, or leave empty to use defaults
	keymaps = {
		insert = "<C-g>s",
		insert_line = "<C-g>S",
		normal = "<leader>s",
		normal_cur = "<leader>ss",
		normal_line = "<leader>S",
		normal_cur_line = "<leader>SS",
		visual = "S",
		visual_line = "gS",
		delete = "<leader>ds",
		change = "<leader>cs",
	},
})
