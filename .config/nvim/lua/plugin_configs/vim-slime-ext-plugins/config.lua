require("plugin_keymaps").pluginKeymaps("vim-slime-ext-plugins")
	vim.g.slime_target_send = "slime_neovim#send"
	vim.g.slime_target_config = "slime_neovim#config"
	vim.g.slime_input_pid=0
	vim.g.ruled_terminal=1
	vim.g.override_status=1
