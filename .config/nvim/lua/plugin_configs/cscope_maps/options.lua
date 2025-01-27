return {
	disable_maps = true,    -- "true" disables default keymaps
	skip_input_prompt = false, -- "true" doesn't ask for input

	-- cscope related defaults
	cscope = {
		-- location of cscope db file
		db_file = "./cscope.out",
		-- cscope executable
		exec = "gtags-cscope",                   -- "cscope" or "gtags-cscope"
		-- choose your fav picker
		picker = "quickfix",               -- "telescope", "fzf-lua" or "quickfix"
		-- "true" does not open picker for single result, just JUMP
		skip_picker_for_single_result = false, -- "false" or "true"
		-- these args are directly passed to "cscope -f <db_file> <args>"
		db_build_cmd = { args = { "-bqkv" } },
		-- statusline indicator, default is cscope executable
		statusline_indicator = nil,
	}
}
