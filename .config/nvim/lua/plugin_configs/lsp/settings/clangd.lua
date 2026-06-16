-- *CLAUDE CHANGE* Flattened for nvim 0.11+ vim.lsp.config API.
-- Previously returned { default_config = {...}, commands = ..., docs = ... }
-- (old nvim-lspconfig shape), which left these fields nested and ignored.
-- nvim-lspconfig's bundled lsp/clangd.lua provides working defaults; this
-- file now only overrides what we actually want to customize.

local function switch_source_header(bufnr)
	bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })
	local clangd_client = clients[1]
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	if clangd_client then
		clangd_client:request('textDocument/switchSourceHeader', params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				print 'Corresponding file cannot be determined'
				return
			end
			vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
		end, bufnr)
	else
		print 'method textDocument/switchSourceHeader is not supported by any servers active on the current buffer'
	end
end

vim.api.nvim_create_user_command('ClangdSwitchSourceHeader', function()
	switch_source_header(0)
end, { desc = 'Switch between source/header' })

return {
	cmd = { 'clangd' },
	filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
	root_markers = {
		'.clangd',
		'.clang-tidy',
		'.clang-format',
		'compile_commands.json',
		'compile_flags.txt',
		'configure.ac',
		'.git',
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-8', 'utf-16' },
	},
}
