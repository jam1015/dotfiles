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
      { "<leader>d",  name = "Diagnostics" }, -- Adding a group name for diagnostics
      { "<leader>de", vim.diagnostic.open_float, desc = "Open Diagnostic Float" },
      { "[d",         vim.diagnostic.goto_prev,  desc = "Go to Previous Diagnostic" },
      { "]d",         vim.diagnostic.goto_next,  desc = "Go to Next Diagnostic" },
      { "<leader>dq", vim.diagnostic.setloclist, desc = "Set Loclist for Diagnostics" },
    }, { mode = "n", silent = false })
  else
    -- Fallback if which-key is not available
    vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, opts)
  end
end

local function local_keymaps(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  if vim.fn.exists("v:lua.vim.lsp.omnifunc") == 1 then
    vim.nvim_set_option_value(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  else
  end

  local bufopts = { noremap = true, silent = false, buffer = bufnr }

  -- Buffer local keymaps using which-key
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.add({
      { "gD",         vim.lsp.buf.declaration,             desc = "Go to Declaration" },
      { "gd",         vim.lsp.buf.definition,              desc = "Go to Definition" },
      { "<leader>kk", vim.lsp.buf.hover,                   desc = "Hover" },
      { "gi",         vim.lsp.buf.implementation,          desc = "Go to Implementation" },
      { "<leader>kk", vim.lsp.buf.signature_help,          desc = "Signature Help" },
      { "<leader>w",  name = "Workspace" }, -- Adding a group name for workspace-related mappings
      { "<leader>wa", vim.lsp.buf.add_workspace_folder,    desc = "Add Workspace Folder" },
      { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
      {
        "<localleader>wl",
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = "List Workspace Folders"
      },
      { "<leader>D",  vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
      { "<leader>rn", vim.lsp.buf.rename,          desc = "Rename Symbol" },
      { "<leader>ca", vim.lsp.buf.code_action,     desc = "Code Action" },
      { "gr",         vim.lsp.buf.references,      desc = "References" },
      {
        "<leader>ff",
        function()
          vim.lsp.buf.format({ async = true })
        end,
        desc = "Format Document"
      },
    }, { mode = "n", buffer = bufnr, silent = false })
  else

    -- Fallback if which-key is not available
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "<leader>kk", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<leader>kk", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<localleader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>ff", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)
  end
end

M.on_attach = function(client, bufnr)
  local_keymaps(bufnr)
  -- Additional on_attach setup can go here
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
     [vim.diagnostic.severity.ERROR] = "" ,
     [vim.diagnostic.severity.WARN] = "" ,
     [vim.diagnostic.severity.HINT] = "" ,
     [vim.diagnostic.severity.INFO] = "" ,
  }


  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
       text = sign_config_table ,
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
