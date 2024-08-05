vim.g.slime_no_mappings = true


vim.g.slime_target_send = "slime_neovim#send"
vim.g.slime_target_config = "slime_neovim#config"

-- two optional functions
-- checks if at least one Neovim terminal is running
vim.g.slime_valid_env = "slime_neovim#valid_env"
-- checks if the configuration is correct
vim.g.slime_valid_config = "slime_neovim#valid_config"

-- I prefer to turn off default mappings; see below for more details
vim.g.slime_no_mappings = true


-- use Neovim's internal Job ID rather than PID to select a terminal
vim.g.slime_input_pid = true

-- Show the Job ID and PID in the status bar of a terminal
vim.g.override_status = true

-- If  true, also show the cursor position in the status bar
vim.g.ruled_status = true
