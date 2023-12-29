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





local function git_root_dir_name()
    -- Get the full path of the current file
    local filepath = vim.fn.expand('%:p:h')
    
    -- Check if the filepath is valid
    if filepath == "" or filepath == nil then
        return ''
    end

    -- Construct and execute the git command
    local git_cmd = "git -C " .. filepath .. " rev-parse --show-toplevel 2> /dev/null"
    local f = io.popen(git_cmd)
    
    -- Check if the command executed successfully
    if not f then
        return ''
    end

    local git_root = f:read("*a")
    f:close()

    -- Check and format the result
    if git_root and #git_root > 0 then
        git_root = string.gsub(git_root, "\n$", "")  -- Trim the newline character
        -- Extract only the base directory name
        local base_dir_name = git_root:match("([^/\\]+)$")
        return base_dir_name
    else
        return ''
    end
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
		lualine_a = { '   ' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { { git_root_dir_name, icon = '' }, '%f' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location', 'b:terminal_job_id', 'b:terminal_job_pid' }
	},
	inactive_sections = {

		lualine_a = { '   ' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { '%f' },
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
