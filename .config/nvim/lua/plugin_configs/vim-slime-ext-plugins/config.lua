require("plugin_keymaps").pluginKeymaps("vim-slime-ext-plugins")
	vim.g.slime_no_mappings = true
	vim.g.slime_target_send = "slime_neovim#send"
	vim.g.slime_target_config = "slime_neovim#config"
	vim.g.slime_input_pid=false
	vim.g.ruled_status=true
	vim.g.override_status=true
