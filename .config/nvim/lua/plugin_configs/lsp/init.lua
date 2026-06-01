-- for in-depth neovim lua development
--require('neodev').setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")

if not lspconfig_status_ok then
	vim.cmd([[colorscheme delek]])
	vim.notify("failed to load lspconfig", vim.log.levels.DEBUG)
	return
end

local servers = {
	"ts_ls",
	"vimls",
	"clangd",
	"pyright",
	"jsonls",
	"cssls",
	"eslint",
	"emmet_ls",
	"texlab",
	"html",
	"bashls",
	"lua_ls",
	"r_language_server",
	"julials",
	"yamlls",
}
--"texlab",

local settings_obj = require("plugin_configs.lsp.mason_settings")

local settings = settings_obj.settings()

require("mason").setup(settings)

require("mason-lspconfig").setup({
	ensure_installed = servers,
})

--local cmp_lsp = require("cmp-nvim-lsp")
local handlers_obj = require("plugin_configs.lsp.lsp_handlers")

handlers_obj.global_keymaps()
--
local opts = {}
for _, server in ipairs(servers) do
	opts = {
		on_attach = handlers_obj.on_attach,
		capabilities = handlers_obj.capabilities,
		flags = handlers_obj.lsp_flags,
	}

	--	--vim.notify("trying to set up " .. server )
	local require_ok, conf_opts = pcall(require, "plugin_configs.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", opts, conf_opts)
	else
	end
	--
	--	--vim.notify("setting up " .. server )
	vim.lsp.config(server, opts)
	vim.lsp.enable(server)
	--  lspconfig[server].setup(opts)
end

handlers_obj.setup()
vim.api.nvim_exec_autocmds("FileType", {})

