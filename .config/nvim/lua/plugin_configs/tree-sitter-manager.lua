require("tree-sitter-manager").setup({
  ensure_installed = { "vimdoc", "markdown_inline",
    "markdown", "vim", "r", "rnoweb", "lua", "c", "python", "html", "typescript", "javascript", "bash", "make", "latex",
    "commonlisp", "json", "yaml" }, -- list of parsers to install at the start of a neovim session
  border = nil,                  -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
  auto_install = false,          -- if enabled, install missing parsers when editing a new file
  highlight = true,              -- treesitter highlighting is enabled by default
  languages = {},                -- override or add new parser sources
  parser_dir = vim.fn.stdpath("data") .. "/site/parser",
  query_dir = vim.fn.stdpath("data") .. "/site/queries",
})

-- Incremental node selection: use Neovim 0.12's built-in vim.treesitter._select
-- (default keybinds are an/in/[n/]n; we also want Tab/S-Tab in visual mode).
vim.keymap.set("x", "<Tab>", function()
  require("vim.treesitter._select").select_parent(vim.v.count1)
end, { desc = "TS: expand selection to parent node" })

vim.keymap.set("x", "<S-Tab>", function()
  require("vim.treesitter._select").select_child(vim.v.count1)
end, { desc = "TS: shrink selection to child node" })
