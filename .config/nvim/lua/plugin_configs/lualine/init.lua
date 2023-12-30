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






--local function vcs_root_dir_name_and_icon()
----	local filepath = vim.fn.expand('%:p:h')
----
----	if filepath == "" or filepath == nil then
----		vim.cmd([[colorscheme blue]])
----		return { name = '', icon = '' }
----	end
----
----	-- Define a table of VCS commands and their icons
----	local vcs_info = {
----		{ cmd = "git -C " .. filepath .. " rev-parse --show-toplevel 2> /dev/null", icon = '' }, -- Git icon
----		{ cmd = "hg --cwd " .. filepath .. " root 2> /dev/null", icon = '☿' }, -- Mercurial icon
----		{ cmd = "svn info --show-item wc-root 2> /dev/null", icon = '𝑆' } -- SVN icon
----	}
----
----	-- Try each VCS command and return the root directory name and icon if found
----	for _, vcs in ipairs(vcs_info) do
----		local f = io.popen(vcs.cmd)
----		if f then
----			local root = f:read("*a")
----			f:close()
----			if root and #root > 0 then
----				root = string.gsub(root, "\n$", "")
----				local base_dir_name = root:match("([^/\\]+)$")
----				return { name = base_dir_name, icon = vcs.icon }
----			end
----		end
----	end
--
--	return { name = 'a', icon = 'b' }
--end
--
--
--
--local repo_info = vcs_root_dir_name_and_icon()

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
			local function base_dir_fun()
				return base_dir_name
			end
			return { base_dir_fun, icon = sys["icon"] }
		end
	end

	-- Return empty string if no VCS root found
	return ''
end


local used_tbl = vcs_root_dir_name()
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
		lualine_c = { used_tbl, '%f' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location', 'b:terminal_job_id', 'b:terminal_job_pid' }
	},
	inactive_sections = {

		lualine_a = { '' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { { vcs_root_dir_name, icon = "?" }, '%f' },
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
