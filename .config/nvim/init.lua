-- __ _  _  _  __  _  _
--(  ( \/ )( \(  )( \/ )!*#
--/    /\ \/ / )( / \/ \!*#
--\_)__) \__/ (__)\_)(_/!*#
local type = "mine" -- "lazy", "debug"

if type == "mine" then
  require('autocommands') --~/.config/nvim/lua/autocommands.lua
  require('keymaps')    -- ~/.config/nvim/lua/keymaps/init.lua
  require('config.lazy') -- ~/.config/nvim/lua/plugins/init.lua
  require('settings')   -- ~/.config/nvim/lua/settings.lua
  -------- ~/.config/nvim/lua/plugin_keymaps.lua
  require('keymaps.post') -- ~/.config/nvim/lua/keymaps/post.lua


elseif type == "debug" then




  --vim.opt.timeoutlen = 500000


  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out,                            "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup({
    spec = {
      {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        },
      }
    },
  })
else
end
