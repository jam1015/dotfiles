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
  -------- ~/.config/nvim/lua/plugin_keymaps.lua
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
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = { delay = 0 },
        --config = function() require("plugin_configs.which-key") end
      },
      {
        "kylechui/nvim-surround",
        --dir = "~/nvim-surround",
        --version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        --event = "VeryLazy",
        config = function()
          require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
          })
        end
      },
    },
  })
else
end
