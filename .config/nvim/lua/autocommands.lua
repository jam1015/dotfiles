local api = vim.api

-- Highlight on yank
local aesthetics = api.nvim_create_augroup("aesthetic_settings", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	command = "silent! lua vim.highlight.on_yank({higroup = \"Visual\", timeout = 200})",
	group = aesthetics,
})

-- concurrency ----------------------------
local function set_concurrent() --lets you edit multiple files at the same time
	vim.v.swapchoice = "e"
	require("notify")("concurrent editing", vim.log.levels.WARN,
		{ timeout = 1000, animate = false, render = "minimal" })
end

local concurrent = api.nvim_create_augroup("concurrent_editing", { clear = true })
api.nvim_create_autocmd("SwapExists", {
	callback = set_concurrent,
	group = concurrent,
})

-- to check if we want to reload the file
vim.api.nvim_create_autocmd({ "FileChangedShellPost", "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' &&  expand('%') !=# '[Command Line]' | checktime | endif",
	pattern = { "*" },
})



vim.cmd([[
autocmd FileChangedShellPost *
\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])
-- terminal related --------------------
local term_autocmds = api.nvim_create_augroup("term_autocomds", { clear = true })




	local function no_term_num()
		local bufnr = vim.api.nvim_get_current_buf()
		local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
		if buftype == 'terminal' then
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
		else
		end
	end

	api.nvim_create_autocmd("TermOpen", {
		callback = no_term_num,
		group = term_autocmds,
	})
--api.nvim_create_autocmd("TermClose", {
--	pattern = "*",
--	command = "if !v:event.status | exe 'Bdelete! '..expand('<abuf>') | endif",
--
--	--command =
--	--"if !v:event.status && len(getbufline(expand('<abuf>'), 1, '$')) == 0 | exe 'bdelete! '..expand('<abuf>') | endif",
--	--command = "if !v:event.status | exe 'Bdelete!' | endif",
--	group = term_autocmds
--})



--local function set_status_line()
--	vim.opt_local.statusline = "%{bufname()}%=id: %{b:terminal_job_id} pid: %{b:terminal_job_pid}"
--end
--
--api.nvim_create_autocmd("TermOpen", {
--	pattern = "*",
--	callback = set_status_line,
--	group = term_autocmds,
--})














