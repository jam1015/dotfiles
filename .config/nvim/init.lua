-- __ _  _  _  __  _  _
--(  ( \/ )( \(  )( \/ )
--/    /\ \/ / )( / \/ \
--\_)__) \__/ (__)\_)(_/

require('autocommands')  -- ~/.config/nvim/lua/autocommands.lua
require('keymaps')       -- ~/.config/nvim/lua/keymaps/init.lua
require('lazy_config')   -- ~/.config/nvim/lua/lazy_config/lazy_plugins.lua
                         -- ~/.config/nvim/lua/plugin_keymaps.lua
require('settings')      -- ~/.config/nvim/lua/settings.lua
require('keymaps.post')  -- ~/.config/nvim/lua/keymaps/post.lua


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
--        spec = {
--                {
--                        "folke/flash.nvim",
--                        event = "VeryLazy",
--                        ---@type Flash.Config
--                        opts = {},
--                        -- stylua: ignore
--                        keys = {
--                                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
--                                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
--                                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
--                                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
--                                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
--                        },
--                },
--                {
--                        'FluxxField/bionic-reading.nvim',
--                        event = "VeryLazy",
--                        config = function()
--                                require('plugin_configs.bionic-reading')
--                        end,
--                },
--
--        },
--})
