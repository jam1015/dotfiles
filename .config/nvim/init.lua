----            .__*
----  _______  _|__| _____
---- /    \  \/ /  |/     \
----|   |  \   /|  |  Y Y  \
----|___|  /\_/ |__|__|_|  /
----     \/              \/
require('autocommands') -- ~/.config/nvim/lua/autocommands.lua
require('keymaps')      -- ~/.config/nvim/lua/keymaps/init.lua
require('lazy_config')  -- ~/.config/nvim/lua/lazy_config/lazy_plugins.lua
--                      -- ~/.config/nvim/lua/plugin_keymaps.lua
require('settings')      -- ~/.config/nvim/lua/settings.lua
require('keymaps.post')  -- ~/.config/nvim/lua/keymaps/post.lua


--vim.api.nvim_set_var('NVIM_LOG_FILE', '~/.cache/nvim/log')
---vim.o.verbosefile = '~/.cache/nvim/verbose.log'
--vim.o.verbose = 15
--
--local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--if not (vim.uv or vim.loop).fs_stat(lazypath) then
--        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
--        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
--        if vim.v.shell_error ~= 0 then
--                vim.api.nvim_echo({
--                        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
--                        { out,                            "WarningMsg" },
--                        { "\nPress any key to exit..." },
--                }, true, {})
--                vim.fn.getchar()
--                os.exit(1)
--        end
--end
--vim.opt.rtp:prepend(lazypath)
--vim.g.mapleader = " "
--vim.g.maplocalleader = "\\"
--require("lazy").setup({
--  spec = {
--    {
--      "jam1015/YankAssassin.nvim",
--      event = "VeryLazy",
--      config = function()
--        require("plugin_configs.YankAssasin")
--      end,
--    }
--  },
--})
