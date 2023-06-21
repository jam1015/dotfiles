require("plugin_keymaps").pluginKeymaps("vim-slime")
	vim.g.slime_target_send = "slime_neovim#send"
	vim.g.slime_target_config = "slime_neovim#config"
	vim.g.slime_input_pid=0
	vim.g.ruled_terminal=1
