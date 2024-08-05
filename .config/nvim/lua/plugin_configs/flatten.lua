---Types:
--
-- Passed to callbacks that handle opening files
-----@alias BufInfo { fname: string, bufnr: buffer }
--
-- The first argument is a list of BufInfo tables representing the newly opened files.
-- The third argument is a single BufInfo table, only provided when a buffer is created from stdin.
--
-- IMPORTANT: For `block_for` to work, you need to return a buffer number OR a buffer number and a window number.
--            The `winnr` return value is not required, `vim.fn.bufwinid(bufnr)` is used if it is not provided.
--            The `filetype` of this buffer will determine whether block should happen or not.
--
-----@alias OpenHandler fun(files: BufInfo[], argv: string[], stdin_buf: BufInfo, guest_cwd: string):window, buffer
--
return {
	callbacks = {
		--			---Called to determine if a nested session should wait for the host to close the file.
		--			---@param argv table a list of all the arguments in the nested session
		--			---@return boolean
		--			should_block = require("flatten").default_should_block,
		--
		--
		--
		---If this returns true, the nested session will be opened.
		---If false, default behavior is used, and
		---config.nest_if_no_args is respected.
		---@type fun(host: channel):boolean
		should_nest = function(host)
			-- don't nest in a neovim terminal (unless nest_if_no_args is set)
			if vim.g.flatten_allow_nesting == true then
				return true
			end
			local filetype = vim.bo.filetype
			if filetype == "gitcommit" or filetype == "gitrebase" then
				return true
			end
			if vim.env.NVIM ~= nil then
				return false
			end

			-- If in a wezterm or kitty split, only open files in the first neovim instance
			-- if their working directories are the same.
			-- This allows you to open a new instance in a different cwd, but open files from the active cwd in your current session.
			local call = "return vim.fn.getcwd(-1)"
			local ok, host_cwd = pcall(vim.rpcrequest, host, "nvim_exec_lua", call, {})

			-- Yield to default behavior if RPC call fails
			if not ok then
				return false
			end

			return not vim.startswith(vim.fn.getcwd(-1), host_cwd)
		end
		--
		--
		--			---Called before a nested session is opened.
		--			pre_open = function() end,
		--
		--
		--
		--			---Called after a nested session is opened.
		--			---@param bufnr buffer
		--			---@param winnr window
		--			---@param filetype string
		--			---@param is_blocking boolean
		--			---@param is_diff boolean
		--			post_open = function(bufnr, winnr, filetype, is_blocking, is_diff) end,
		--
		--
		--
		--			---Called when a nested session is done waiting for the host.
		--			---@param filetype string
		--			block_end = function(filetype) end,
	},
	-- <String, Bool> dictionary of filetypes that should be blocking
	block_for = {
		gitcommit = true
	},
	-- Command passthrough
	allow_cmd_passthrough = true,
	-- Allow a nested session to open if Neovim is opened without arguments
	nest_if_no_args = true,
	-- Window options
	window = {
		-- Options:
		-- current        -> open in current window (default)
		-- alternate      -> open in alternate window (recommended)
		-- tab            -> open in new tab
		-- split          -> open in split
		-- vsplit         -> open in vsplit
		-- smart          -> smart open (avoids special buffers)
		-- OpenHandler    -> allows you to handle file opening yourself (see Types)
		--
		open = "current",
		-- Options:
		-- vsplit         -> opens files in diff vsplits
		-- split          -> opens files in diff splits
		-- tab_vsplit     -> creates a new tabpage, and opens diff vsplits
		-- tab_split      -> creates a new tabpage, and opens diff splits
		-- OpenHandler    -> allows you to handle file opening yourself (see Types)
		diff = "tab_vsplit",
		-- Affects which file gets focused when opening multiple at once
		-- Options:
		-- "first"        -> open first file of new files (default)
		-- "last"         -> open last file of new files
		focus = "first"
	},
	-- Override this function to use a different socket to connect to the host
	-- On the host side this can return nil or the socket address.
	-- On the guest side this should return the socket address
	-- or a non-zero channel id from `sockconnect`
	-- flatten.nvim will detect if the address refers to this instance of nvim, to determine if this is a host or a guest
	--pipe_path = require'flatten'.default_pipe_path,
	-- The `default_pipe_path` will treat the first nvim instance within a single kitty/wezterm session as the host
	-- You can configure this behaviour using the following:
	one_per = {
		kitty = true, -- Flatten all instance in the current Kitty session
		wezterm = true, -- Flatten all instance in the current Wezterm session
	},
}
