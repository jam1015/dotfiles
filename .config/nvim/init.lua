-- __ _  _  _  __  _  _
--(  ( \/ )( \(  )( \/ )!*
--/    /\ \/ / )( / \/ \!*
--\_)__) \__/ (__)\_)(_/!

require('autocommands')  -- ~/.config/nvim/lua/autocommands.lua
require('keymaps')       -- ~/.config/nvim/lua/keymaps/init.lua
require('lazy_config')   -- ~/.config/nvim/lua/lazy_config/lazy_plugins.lua
-- ~/.config/nvim/lua/plugin_keymaps.lua
require('settings')      -- ~/.config/nvim/lua/settings.lua
require('keymaps.post')  -- ~/.config/nvim/lua/keymaps/post.lua




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
--
--    {
--      "folke/which-key.nvim",
--      opts = require("plugin_configs.which-key")
--    },
--    {
--      "nvim-telescope/telescope.nvim",
--      enabled = true,
--      dependencies = { {"nvim-lua/plenary.nvim"},
--        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
--        {"nvim-telescope/telescope-file-browser.nvim"} },
--      config = function()
--        require('telescope').setup{
--          defaults = {
--            -- Default configuration for telescope goes here:
--            -- config_key = value,
--            mappings = {
--              i = {
--                -- map actions.which_key to <C-h> (default: <C-/>)
--                -- actions.which_key shows the mappings for your picker,
--                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
--                ["<C-h>"] = "which_key"
--              }
--            }
--          },
--          pickers = {
--            -- Default configuration for builtin pickers goes here:
--            -- picker_name = {
--            --   picker_config_key = value,
--            --   ...
--            -- }
--            -- Now the picker_config_key will be applied every time you call this
--            -- builtin picker
--          },
--          extensions = {
--            extensions = {
--              fzf = {
--                fuzzy = true,                    -- false will only do exact matching
--                override_generic_sorter = true,  -- override the generic sorter
--                override_file_sorter = true,     -- override the file sorter
--                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
--                -- the default case_mode is "smart_case"
--              }
--            }
--          }
--        }
--        require('telescope').load_extension('fzf')
--      end
--    },
--  },
--})
