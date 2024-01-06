local ok, my_custom_theme = pcall(require, 'plugin_configs.lualine.my_auto_theme')

-- ~/.config/nvim/lua/plugin_configs/lualine/my_auto_theme.lua

local used_theme = nil
if ok then
	used_theme = my_custom_theme('normal')
	--vim.cmd([[colorscheme delek]])
else
	used_theme = 'auto'
	--vim.cmd([[colorscheme blue]])
end


local function vcs_root_dir_name()
	-- Get the full path of the current file
	local filepath = vim.fn.expand('%:p:h')

	-- Check if the filepath is valid
	if filepath == "" or filepath == nil then
		return ''
	end

	-- Function to get root directory from command
	local function get_vcs_root(cmd)
		local f = io.popen(cmd)
		if not f then return nil end
		local root = f:read("*a")
		f:close()
		return (root and #root > 0) and string.gsub(root, "\n$", "") or nil
	end

	-- Check for each VCS and get root directory
	local vcs_sys = {
		git = { command = "git -C " .. filepath .. " rev-parse --show-toplevel 2> /dev/null", icon = "󰊢" },
		hg  = { command = "hg --cwd " .. filepath .. " root 2> /dev/null", icon = "☿" },
		svn = { command = "svn info --show-item wc-root " .. filepath .. " 2> /dev/null", icon = "𝕊" },
	}

	for _, sys in pairs(vcs_sys) do
		local root = get_vcs_root(sys["command"])
		if root then
			-- Extract only the base directory name
			local base_dir_name = root:match("([^/\\]+)$")
			return base_dir_name
		end
	end

	-- Return empty string if no VCS root found
	return ''
end

local function vcs_icony()
	-- Get the full path of the current file
	local filepath = vim.fn.expand('%:p:h')

	-- Check if the filepath is valid
	if filepath == "" or filepath == nil then
		return ''
	end

	-- Function to get root directory from command
	local function get_vcs_root(cmd)
		local f = io.popen(cmd)
		if not f then return nil end
		local root = f:read("*a")
		f:close()
		return (root and #root > 0) and string.gsub(root, "\n$", "") or nil
	end

	-- Check for each VCS and get root directory
	local vcs_sys = {
		git = { command = "git -C " .. filepath .. " rev-parse --show-toplevel 2> /dev/null", icon = "󰊢" },
		hg  = { command = "hg --cwd " .. filepath .. " root 2> /dev/null", icon = "☿" },
		svn = { command = "svn info --show-item wc-root " .. filepath .. " 2> /dev/null", icon = "𝕊" },
	}

	for _, sys in pairs(vcs_sys) do
		local root = get_vcs_root(sys["command"])
		if root then
			-- Extract only the base directory name
			return sys["icon"]
		end
	end

	-- Return empty string if no VCS root found
	return ''
end

local function vcs_icon()
	return vim.b.buffer_icon
end
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = used_theme,
		--'mytheme', --'auto',
		--component_separators = { left = '', right = '' },
		--section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},

	sections = {
		lualine_a = { '' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { {"b:vcs_root_dir_name", icon = vcs_icon()}, '%f' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location', 'b:terminal_job_id', 'b:terminal_job_pid' }
	},
	inactive_sections = {

		lualine_a = { '' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { {vcs_root_dir_name, icon = vcs_icon()}, '%f' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location', 'b:terminal_job_id', 'b:terminal_job_pid' }
		--		lualine_a = {},
		--		lualine_b = {},
		--		lualine_c = { 'filename' },
		--		lualine_x = { 'location' },
		--		lualine_y = {},
		--		lualine_z = { 'b:terminal_job_id', 'b:terminal_job_pid' }
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}
