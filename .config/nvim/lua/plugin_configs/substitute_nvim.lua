require("substitute").setup({
	{
		on_substitute = nil,
		yank_substituted_text = false,
		highlight_substituted_text = {
			enabled = true,
			timer = 500,
		},
		range = {
			prefix = nil,
			prompt_current_text = false,
			confirm = false,
			complete_word = false,
			motion1 = false,
			motion2 = false,
			suffix = "",
		},
		exchange = {
			motion = true,
			use_esc_to_cancel = true,
		},
	}

})
