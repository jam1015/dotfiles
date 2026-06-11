-- *CLAUDE CHANGE* single source of truth for LSP servers + their filetypes.
-- Used by plugin spec (for `ft` lazy-trigger) and by lsp/init.lua (for ensure_installed).
-- To add a server: add an entry below and (optionally) a settings file at
-- plugin_configs/lsp/settings/<server>.lua.

local M = {}

M.servers = {
	ts_ls             = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	-- *CLAUDE CHANGE* re-enabled — culprit was `q:` (command-line window has ft=vim).
	-- It still triggers lspconfig load when you use `q:`, but `vi <file>.toml` is unaffected.
	vimls             = { "vim" },
	clangd            = { "c", "cpp", "objc", "objcpp", "cuda" },
	pyright           = { "python" },
	jsonls            = { "json", "jsonc" },
	cssls             = { "css", "scss", "less" },
	eslint            = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	emmet_ls          = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
	texlab            = { "tex", "plaintex", "bib" },
	html              = { "html" },
	bashls            = { "sh", "bash", "zsh" },
	lua_ls            = { "lua" },
	r_language_server = { "r", "rmd", "quarto" },
	julials           = { "julia" },
	-- *CLAUDE CHANGE* added yamlls subtypes flagged by `:checkhealth vim.lsp`
	-- (yaml.docker-compose, yaml.gitlab, yaml.helm-values).
	yamlls            = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
}

function M.names()
	local out = {}
	for name, _ in pairs(M.servers) do
		table.insert(out, name)
	end
	return out
end

function M.filetypes()
	local seen, out = {}, {}
	for _, fts in pairs(M.servers) do
		for _, ft in ipairs(fts) do
			if not seen[ft] then
				seen[ft] = true
				table.insert(out, ft)
			end
		end
	end
	return out
end

return M
