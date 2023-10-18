-- First, ensure you have nvim-lspconfig installed and loaded

local lspconfig = require('lspconfig')

-- Helper function to search for a root marker file upwards in the directory tree
local root_pattern = lspconfig.util.root_pattern

-- Configuration for Lua (sumneko) language server
lspconfig.lua_ls.setup({
	cmd = {"/Users/jordanmandel/Documents/lua-language-server/bin/lua-language-server", "-E", "/Users/jordanmandel/Documents/lua-language-server/bin/main.lua"},
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				enable = true,
				globals = {'vim'},
			},
			workspace = {
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
				},
			},
		},
	},
	root_dir = function(filename)
		return root_pattern(".git")(filename) or
		root_pattern("init.lua", "main.lua", ".lua")(filename) or
		lspconfig.util.path.dirname(filename)
	end
})

