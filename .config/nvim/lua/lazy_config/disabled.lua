  
    ------------- disabled ----------
  
    {
      'nvim-tree/nvim-tree.lua',
      enabled = false,
      event = "VeryLazy",
      config = function()
        require("plugin_configs.nvim-tree")
        require("plugin_keymaps").nvim_tree()
      end
  
  
    },
  
    {
      'ggandor/leap-ast.nvim',
      -- right now prefer treehopper because it gives more hints
      config = function() require("plugin_keymaps").leap_ast() end,
      enabled = false,
  
    },
    {
      "mfussenegger/nvim-treehopper",
      enabled = true,
      event = "VeryLazy",
      dependencies = "phaazon/hop.nvim",
      config = function() require("plugin_configs.nvim-treehopper") end,
    },
    {
      'altermo/nxwm',
      enabled = false,
      branch = 'x11',
      config = function()
        require('plugin_configs.nxwm')
      end
    },
    {
      -- startup screen
      "goolord/alpha-nvim",
      enabled = false,
      cond = require("plugin_configs.alpha-nvim.cond"),
      config = function()
        require("plugin_configs.alpha-nvim.config")
      end,
  
    },
    ({
      "neoclide/coc.nvim",
      branch = "release",
      enabled = false,
      dependencies = { "neoclide/coc-snippets" },
      init = function()
        require("plugin_configs.coc")
      end,
      event = "VeryLazy",
    }),
  
    { "tpope/vim-scriptease", enabled = false }, -- messes with s mapping of leap
  
    {
      "josa42/nvim-gx",
      enabled = false,
      config = function()
        vim.keymap.set('n', 'gx', require('gx').gx)
      end
    },
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("plugin_configs.namu")
    end
  },
