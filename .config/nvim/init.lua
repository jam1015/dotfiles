--███╗   ██╗██╗   ██╗██╗███╗   ███╗         ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
--████╗  ██║██║   ██║██║████╗ ████║        ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
--██╔██╗ ██║██║   ██║██║██╔████╔██║        ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
--██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║        ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
--██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║███████╗╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
require('autocommands') -- ~/.config/nvim/lua/autocommands.lua
require('keymaps')      -- ~/.config/nvim/lua/keymaps/init.lua
require('lazy_config')  -- ~/.config/nvim/lua/lazy_config/lazy_plugins.lua
                        -- ~/.config/nvim/lua/plugin_keymaps.lua
require('settings')     -- ~/.config/nvim/lua/settings.lua
require('keymaps.post') -- ~/.config/nvim/lua/keymaps/post.lua

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
--vim.g.mapleader = " "
--vim.g.maplocalleader = "\\"
--require("lazy").setup({
--  spec = {
--    {
--      "neovim/nvim-lspconfig",
--      config = function()
--        require'lspconfig'.lua_ls.setup{}
--        vim.keymap.set("n", "gd", vim.lsp.buf.definition )
--      end
--    },
--    {
--      "folke/lazydev.nvim", 
--      ft = "lua",
--      opts = {
--      --  library = {
--      --    -- Library paths can be absolute
--      --    "~/projects/my-awesome-lib",
--      --    -- Or relative, which means they will be resolved from the plugin dir.
--      --    "lazy.nvim",
--      --    "luvit-meta/library",
--      --    -- It can also be a table with trigger words / mods
--      --    -- Only load luvit types when the `vim.uv` word is found
--      --    { path = "luvit-meta/library", words = { "vim%.uv" } },
--      --    -- always load the LazyVim library
--      --    "LazyVim",
--      --    -- Only load the lazyvim library when the `LazyVim` global is found
--      --    { path = "LazyVim", words = { "LazyVim" } },
--      --    -- Load the wezterm types when the `wezterm` module is required
--      --    -- Needs `justinsgithub/wezterm-types` to be installed
--      --    { path = "wezterm-types", mods = { "wezterm" } },
--      --    -- Load the xmake types when opening file named `xmake.lua`
--      --    -- Needs `LelouchHe/xmake-luals-addon` to be installed
--      --    { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
--      --  },
--      --  -- always enable unless `vim.g.lazydev_enabled = false`
--      --  -- This is the default
--      --  enabled = function(root_dir)
--      --    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
--      --  end,
--      --  -- disable when a .luarc.json file is found
--      --  enabled = function(root_dir)
--      --    return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
--      --  end,
--      },
--
--    }
--  },
--}
