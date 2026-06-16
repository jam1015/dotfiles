local M = {}

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok and vim.g.debug then
  --vim.cmd([[colorscheme delek]])
  vim.notify("Failed to load cmp_nvim_lsp\n")
end

M.global_keymaps = function()
  local opts = { noremap = true, silent = false }

  -- Global keymaps using which-key
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.add({
      { "<leader>d", group = "LSP Diagnostics" }, -- Adding a group name for diagnostics
      {
        "<leader>de",
        vim.diagnostic.open_float,
        desc = "Open Diagnostic Float",
      },
      {
        "[d",
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end,
        desc = "Go to Previous Diagnostic",
      },
      {
        "]d",
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end,
        desc = "Go to Next Diagnostic",
      },
      {
        "<leader>dq",
        vim.diagnostic.setloclist,
        desc = "Set Loclist for Diagnostics",
      },
    }, { mode = "n", silent = false })
  else
    -- Fallback if which-key is not available
    vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, opts)
  end
end

local function local_keymaps(bufnr)
  if vim.fn.exists("v:lua.vim.lsp.omnifunc") == 1 then
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
  end

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = false, desc = desc })
  end

  -- g-prefixed navigation
  map("gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("gd", vim.lsp.buf.definition, "Go to Definition")
  map("gi", vim.lsp.buf.implementation, "Go to Implementation")
  map("gr", vim.lsp.buf.references, "References")

  -- <leader>l = LSP
  map("<leader>lh", vim.lsp.buf.hover, "Hover")
  map("<leader>ls", vim.lsp.buf.signature_help, "Signature Help")
  map("<leader>ld", vim.lsp.buf.type_definition, "Type Definition")
  map("<leader>lr", vim.lsp.buf.rename, "Rename Symbol")
  map("<leader>la", vim.lsp.buf.code_action, "Code Action")
  map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")

  -- <leader>lw = workspace
  map("<leader>lwa", vim.lsp.buf.add_workspace_folder, "Add Folder")
  map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove Folder")
  map("<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List Folders")

  -- <leader>lt = toggles
  map("<leader>lti", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
  end, "Toggle Inlay Hints")
  map("<leader>ltl", function()
    if vim.b[bufnr].codelens_enabled == nil then
      vim.b[bufnr].codelens_enabled = true
    end
    vim.b[bufnr].codelens_enabled = not vim.b[bufnr].codelens_enabled
    if vim.b[bufnr].codelens_enabled then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.notify("Code lens enabled")
    else
      vim.lsp.codelens.clear(nil, bufnr)
      vim.notify("Code lens disabled")
    end
  end, "Toggle Code Lens")
  map("<leader>ltd", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, "Toggle Diagnostics")

  -- Register group labels with which-key (buffer-local). Maps themselves
  -- are set via vim.keymap.set above; which-key v3 picks up their `desc`.
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.add({
      { "<leader>l",  group = "LSP",       buffer = bufnr },
      { "<leader>lw", group = "Workspace", buffer = bufnr },
      { "<leader>lt", group = "Toggles",   buffer = bufnr },
    }, { mode = "n" })
  end
end

-- *CLAUDE CHANGE* Belt-and-suspenders: bind LSP keymaps via LspAttach autocmd
-- in addition to the on_attach config field. This is the canonical 0.11+
-- pattern and fires reliably for every client attach (including :LspRestart),
-- regardless of how the server was configured.
vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "UserLspKeymaps",
  callback = function(args)
    local_keymaps(args.buf)
  end,
})

M.on_attach = function(client, bufnr)
  local_keymaps(bufnr)

  --if client.server_capabilities.documentHighlightProvider then
  --	local group = vim.api.nvim_create_augroup("LspDocHighlight_" .. bufnr, { clear = true })
  --	vim.api.nvim_create_autocmd("CursorHold", {
  --		group = group,
  --		buffer = bufnr,
  --		callback = vim.lsp.buf.document_highlight,
  --	})
  --	vim.api.nvim_create_autocmd("CursorMoved", {
  --		group = group,
  --		buffer = bufnr,
  --		callback = vim.lsp.buf.clear_references,
  --	})
  --end

  --if client.server_capabilities.inlayHintProvider then
  --	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  --end

  --if client.server_capabilities.codeLensProvider then
  --	local group = vim.api.nvim_create_augroup("LspCodeLens_" .. bufnr, { clear = true })
  --	vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
  --		group = group,
  --		buffer = bufnr,
  --		callback = vim.lsp.codelens.refresh,
  --	})
  --end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true -- Enable snippet support

if status_ok then
  M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

M.lsp_flags = {
  -- Allow using incremental sync for buffer edits
  allow_incremental_sync = true,
  -- Debounce didChange notifications to the server in milliseconds (default=150 in Nvim 0.7+)
  debounce_text_changes = 150,
}

M.setup = function() -- more setup things
  local sign_config_table = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.HINT] = "",
    [vim.diagnostic.severity.INFO] = "",
  }

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      text = sign_config_table,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      --border = "straight",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)
end

return M
