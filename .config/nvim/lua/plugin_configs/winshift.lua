local api = vim.api
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Configuration options for floating window appearance
local float_config = {
	float_height = 3,
	float_width = 6,
	chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
	hint_hl = "StatusLine",
	normal_hl = "StatusLine",
}

local function create_hint_floats(selectable, chars)
	local floats = {}
	for i, win_id in ipairs(selectable) do
		local bufnr = api.nvim_create_buf(false, true)
		local key = chars:sub(i, i)
		local win_width = api.nvim_win_get_width(win_id)
		local win_height = api.nvim_win_get_height(win_id)

		--local row = math.floor((win_height - float_config.float_height) / 2)
		local row = math.max(0, math.floor((win_height / 2) - 1))

		--local col = math.floor((win_width - float_config.float_width) / 2)
		local col = math.max(0, math.floor((win_width / 2) - float_config.float_width))

		api.nvim_buf_set_lines(bufnr, 0, -1, true, { '', '  ' .. trim(key) .. '  ', '' })
		api.nvim_buf_add_highlight(bufnr, 0, float_config.hint_hl, 0, 0, -1)

		local float_win = api.nvim_open_win(bufnr, false, {
			relative = "win",
			win = win_id,
			row = row,
			col = col,
			width = #key == 1 and float_config.float_width - 1 or float_config.float_width,
			height = float_config.float_height,
			style = "minimal",
			border = "single",
			noautocmd = true,
		})

		api.nvim_set_option_value(
			'winhl',
			'Normal:' .. float_config.normal_hl,
      {win = float_win}
		)

		floats[key] = { float_win = float_win, target_win = win_id }
		i = i + 1
		if i > #chars then break end
	end
	return floats
end

local function close_hint_floats(floats)
	for _, float_info in pairs(floats) do
		api.nvim_win_close(float_info.float_win, true)
	end
end


local function my_pick_window(opt)
	opt = opt or {}
	local tabpage = api.nvim_get_current_tabpage()
	local win_ids = api.nvim_tabpage_list_wins(tabpage)
	local curwin = api.nvim_get_current_win()
	local filter_rules = opt.filter_rules or {}

	local selectable = vim.tbl_filter(function(id)
		if filter_rules.cur_win and curwin == id then
			return false
		elseif filter_rules.floats and api.nvim_win_get_config(id).relative ~= "" then
			return false
		end

		local bufid = api.nvim_win_get_buf(id)
		local bufname = api.nvim_buf_get_name(bufid)

		for _, option in ipairs({ "filetype", "buftype" }) do
			if vim.tbl_contains(filter_rules[option] or {}, vim.bo[bufid][option]) then
				return false
			end
		end

		for _, pattern in ipairs(filter_rules.bufname or {}) do
			local regex = vim.regex(pattern)
			if regex:match_str(bufname) ~= nil then
				return false
			end
		end

		return true
	end, win_ids)

	if opt.filter_func then
		selectable = opt.filter_func(selectable)
	end

	-- If there are no selectable windows: return. If there's only 1, return it without picking.
	if #selectable == 0 then return -1 end
	if #selectable == 1 then return selectable[1] end

	local chars = (opt.picker_chars or "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"):upper()

	-- Setup UI
	local floats = create_hint_floats(selectable, chars)

	vim.cmd("redraw")
	local ok, char = pcall(vim.fn.getcharstr)
	if not ok then char = "" end
	char = char:upper()

	close_hint_floats(floats)
	local selected_win = floats[char] and floats[char].target_win or nil
	if selected_win then
		return floats[char].target_win
	else
		return
	end
end

require("winshift").setup({
	highlight_moving_win = true, -- Highlight the window being moved
	focused_hl_group = "Visual", -- The highlight group used for the moving window
	moving_win_options = {
		-- These are local options applied to the moving window while it's
		-- being moved. They are unset when you leave Win-Move mode.
		wrap = false,
		cursorline = false,
		cursorcolumn = false,
		colorcolumn = "",
	},
	keymaps = {
		disable_defaults = false, -- Disable the default keymaps
		win_move_mode = {
			["h"] = "left",
			["j"] = "down",
			["k"] = "up",
			["l"] = "right",
			["H"] = "far_left",
			["J"] = "far_down",
			["K"] = "far_up",
			["L"] = "far_right",
			["<left>"] = "left",
			["<down>"] = "down",
			["<up>"] = "up",
			["<right>"] = "right",
			["<S-left>"] = "far_left",
			["<S-down>"] = "far_down",
			["<S-up>"] = "far_up",
			["<S-right>"] = "far_right",
		},
	},
	---A function that should prompt the user to select a window.
	---
	---The window picker is used to select a window while swapping windows with
	---`:WinShift swap`.
	---@return integer? winid # Either the selected window ID, or `nil` to
	---   indicate that the user cancelled / gave an invalid selection.
	window_picker = function()
		return my_pick_window({
			-- A string of chars used as identifiers by the window picker.
			picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
			filter_rules = {
				-- This table allows you to indicate to the window picker that a window
				-- should be ignored if its buffer matches any of the following criteria.
				cur_win = true, -- Filter out the current window
				floats = true, -- Filter out floating windows
				filetype = {}, -- List of ignored file types
				buftype = {}, -- List of ignored buftypes
				bufname = {}, -- List of vim regex patterns matching ignored buffer names
			},
			---A function used to filter the list of selectable windows.
			---@param winids integer[] # The list of selectable window IDs.
			---@return integer[] filtered # The filtered list of window IDs.
			filter_func = nil,
		})
	end,
})

