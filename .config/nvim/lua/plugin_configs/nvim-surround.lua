require("nvim-surround").setup({
	-- Configuration here, or leave empty to use defaults
	keymaps = {
		insert = "<C-g>s",
		insert_line = "<C-g>S",
		normal = "<leader>ys",
		normal_cur = "<leader>yss",
		normal_line = "<leader>yS",
		normal_cur_line = "<leader>ySS",
		visual = "S",
		visual_line = "gS",
		delete = "<leader>ds",
		change = "<leader>cs",
	},
})
