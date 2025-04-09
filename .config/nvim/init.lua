-- __ _  _  _  __  _  _
--(  ( \/ )( \(  )( \/ )!*
--/    /\ \/ / )( / \/ \!*
--\_)__) \__/ (__)\_)(_/!*

require('autocommands')  -- ~/.config/nvim/lua/autocommands.lua
require('keymaps')       -- ~/.config/nvim/lua/keymaps/init.lua
require('lazy_config')   -- ~/.config/nvim/lua/lazy_config/lazy_plugins.lua
------ ~/.config/nvim/lua/plugin_keymaps.lua
require('settings')      -- ~/.config/nvim/lua/settings.lua
require('keymaps.post')  -- ~/.config/nvim/lua/keymaps/post.lua
--
--local is_gui = vim.g.neovide or vim.g.neovim_qt or vim.g.goneovim
--
--if is_gui then
--  print("Neovim is running in a GUI!")
--else
--  print("Neovim is running in a terminal.")
--end

--vim.g.mapleader = " "
--vim.g.maplocalleader = "\\"
--local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--if not (vim.uv or vim.loop).fs_stat(lazypath) then
--  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
--  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
--  if vim.v.shell_error ~= 0 then
--    vim.api.nvim_echo({
--      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
--      { out,                            "WarningMsg" },
--      { "\nPress any key to exit..." },
--    }, true, {})
--    vim.fn.getchar()
--    os.exit(1)
--  end
--end
--vim.opt.rtp:prepend(lazypath)
--require("lazy").setup({
--  spec = {
--    {
--      "willothy/flatten.nvim",
--      config = true,
--      -- or pass configuration with
--      -- opts = {  }
--      -- Ensure that it runs first to minimize delay when opening file from terminal
--      lazy = false,
--      priority = 1001,
--    },
--
--  },
--})
