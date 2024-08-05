--vim.cmd([[
--"highlight IndentBlanklineChar guifg=#00FF00 gui=nocombine
--"highlight IndentBlanklineSpaceChar guifg=#00FF00 gui=nocombine
--"
--"
--"        highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine
--"
--"        highlight IndentBlanklineContextSpaceChar guifg=#00FF00 gui=nocombine
--"        highlight IndentBlanklineContextStart guisp=#00FF00 gui=underline
--
--
--]])
--
--require("ibl").setup({
--	highlight = { "Function", "Label" },
--	remove_blankline_trail = true,
--})


require("ibl").setup ({
	--indent = { highlight = highlight, char = "" },
	indent = {char = "│"},
	whitespace = {
		--highlight = highlight,
		remove_blankline_trail = true,
	},
	scope = { enabled = false },
	exclude = {filetypes = {"text"}}
})
