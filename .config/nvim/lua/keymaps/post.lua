local ok, wk = pcall(require, 'which-key')
if not ok then
  vim.notify("which-key not installed", vim.log.levels.DEBUG)
else
  local wk_opts = {
    mode = "n", -- NORMAL mode
    -- prefix: use "<leader>f" for example for mapping everything related to finding files
    -- the prefix is prepended to every mapping part of `mappings`
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false, -- use `expr` when creating keymaps
  }

  wk.add(

    {
      { "<leader>tl", "<C-w>s<cmd>terminal<cr>", desc = "Open Terminal Hsplit" },
      { "<leader>tn", "<cmd>tabnew<cr>",         desc = "New Tab" },
      { "<leader>tt", "<cmd>terminal<cr>",       desc = "Open Terminal" },
      { "<leader>tv", "<C-w>v<cmd>terminal<cr>", desc = "Open Terminal Vsplit" },
    }

  )
  wk.add(
  {
    { "<leader>l", group = "aesthetics" },
    { "<leader>ll", "<cmd>nohlsearch<CR>", desc = "nohighlight" },
  }
)
end
