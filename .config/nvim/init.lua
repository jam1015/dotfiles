-- __ _  _  _  __  _  _
--(  ( \/ )( \(  )( \/ )!*#
--/    /\ \/ / )( / \/ \!*#
--\_)__) \__/ (__)\_)(_/!*#
local type = "mine" -- "lazy", "debug"

if type == "mine" then
  require('autocommands') --~/.config/nvim/lua/autocommands.lua
  require('keymaps')      -- ~/.config/nvim/lua/keymaps/init.lua
  require('lazyspec')     -- ~/.config/nvim/lua/plugins/init.lua
  require('settings')     -- ~/.config/nvim/lua/settings.lua
--  -------- ~/.config/nvim/lua/plugin_keymaps.lua
  require('keymaps.post') -- ~/.config/nvim/lua/keymaps/post.lua
elseif type == "debug" then
  vim.opt.timeoutlen = 1000


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
        "jam1015/vim-slime",
--        event = "VeryLazy",
        init = function()
          require("plugin_configs.vim-slime.initi")

          vim.g.slime_target = "neovim"
          vim.g.slime_no_mappings = true
          vim.g.slime_input_pid = true
          vim.g.slime_suggest_default = true
          vim.g.slime_bracketed_paste = true
          vim.g.slime_menu_config = true
        end,

        keys = {
          { "<leader>is", "<Plug>SlimeRegionSend", mode = "x", desc = "Send Selection" },
          { "<leader>it", "<Plug>SlimeMotionSend", mode = "n", desc = "Send Text Object" },
          { "<leader>il", "<Plug>SlimeLineSend",   mode = "n", desc = "Send Line" },
          { "<leader>ic", "<Plug>SlimeConfig",     mode = "n", desc = "Slime Config" },
        },
      },
    },
  })
else
end
