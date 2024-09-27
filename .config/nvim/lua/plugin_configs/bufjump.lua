require("bufjump").setup({
  forward_key = false,
  backward_key = false,
  on_success = function()
    vim.cmd([[execute "normal! g`\"zz"]])
  end,
})

require("plugin_keymaps").bufjump()
