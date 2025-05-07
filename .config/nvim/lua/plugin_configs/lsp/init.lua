-- for in-depth neovim lua development
--require('neodev').setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")

if not lspconfig_status_ok then
  vim.cmd([[colorscheme blue]])
  vim.notify("failed to load lspconfig", vim.log.levels.DEBUG)
  return
end

local servers = { "ts_ls", "vimls", "clangd", "pyright", "jsonls", "cssls", "eslint",
  "emmet_ls", "texlab", "html", "bashls",
  "lua_ls",
  "julials" }
--"r_language_server",
--"texlab",

local settings_obj = require("plugin_configs.lsp.mason_settings")

local settings = settings_obj.settings()

require("mason").setup(settings)

require("mason-lspconfig").setup({
  ensure_installed       = servers,
  automatic_installation = true --if we set it up with lspconfig then we install it
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
    flags = handlers_obj.lsp_flags
  }

  --	--vim.notify("trying to set up " .. server )
  local require_ok, conf_opts = pcall(require, "plugin_configs.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  else
  end
  --
  --	--vim.notify("setting up " .. server )
  vim.lsp.enable(server)
  vim.lsp.config(server,opts)
--  lspconfig[server].setup(opts)
end

handlers_obj.setup()
vim.api.nvim_exec_autocmds("FileType", {})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local current_buf = args.buf

    if client then
      local clients = vim.lsp.get_clients({ id = client_id })
      local count = 0

      if clients and #clients > 0 then
        local remaining_client = clients[1]

        if remaining_client.attached_buffers then
          for buf_id in pairs(remaining_client.attached_buffers) do
            if buf_id ~= current_buf then
              count = count + 1
            end
          end
        end
      end

      if count == 0 then
        client.stop(false)
      end
    end
  end
})
