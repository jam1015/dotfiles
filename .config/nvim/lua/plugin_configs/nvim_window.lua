require('nvim-window').setup({
	-- The characters available for hinting windows.
	chars = {
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
		'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
	},

	-- A group to use for overwriting the Normal highlight group in the floating
	-- window. This can be used to change the background color.
	--normal_hl = 'Normal',
	normal_hl = 'StatusLine',

	-- The highlight group to apply to the line that contains the hint characters.
	-- This is used to make them stand out more.
	--hint_hl = 'Bold',
	hint_hl = 'StatusLine',

	-- The border style to use for the floating window.
	border = 'single',
  only_uppercase = true
})
