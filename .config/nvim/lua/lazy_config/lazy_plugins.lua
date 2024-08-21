local os_name = vim.loop.os_uname().sysname
local lisp_lazy = function() --also done vi autocmd in the cmp config
  if (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp") then
    return false
  else
    return true
  end
end

return {
  {
    "folke/lazydev.nvim",
    --event = "VeryLazy",
    ft = "lua",                                   -- only load on lua files
    opts = require("plugin_configs.lazydev_nvim") --enabled = false

  },
  { "Bilal2453/luvit-meta",        lazy = true }, -- optional `vim.uv` typings
  {
    "leath-dub/snipe.nvim",
    enabled = false,
    config = function()
      require("plugin_configs.snipe")
      require("plugin_keymaps").snipe()
    end
  },
  {
    "ggandor/flit.nvim",
    enabled = false,
    event = "VeryLazy",
    --commit = "f60e4b3d49bb5a5e97cfffe66f2e671eb422078e",
    config = function() require("plugin_configs.flit") end,
    dependencies = { { 'tpope/vim-repeat' }, { 'ggandor/leap.nvim' } }
  },
  {
    -- using leap instead
    "ggandor/leap.nvim",
    enabled = false,
    event = "VeryLazy",
    --commit ="8facf2eb6a378fd7691dce8c8a7b2726823e2408",
    config = function()
      require('plugin_keymaps').leap()
    end
  },
  {
    'jam1015/winshift.nvim',
    enabled = true,
    --dir = "~/Documents/vim_plugins/winshift.nvim",
    branch = "my_merged",
    config = function()
      require("plugin_configs.winshift")
      require("plugin_keymaps").nvim_winshift()
    end
  },
  {

    "jam1015/nvim-window",
    branch = "only_uppercase",
    enabled = true,
    config = function()
      require("plugin_configs.nvim_window")
      require("plugin_keymaps").nvim_window()
      return true
    end,
  },
  {

    'jam1015/buf_hint_nvim',
    dir = "~/Documents/vim_plugins/buf_hint_nvim",
    config = function()
      --require("buf_hint_nvim").setup()
    end

  },
  {
    'nvimdev/lspsaga.nvim',
    enabled = false,
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
    }
  },
  {
    "jpalardy/vim-slime",
    dir = "~/vim-slime",
    init = function()
      require("plugin_configs.vim-slime.initi")
    end,

    config = function()
      require("plugin_configs.vim-slime.config")
    end,
  },
  {
    "jam1015/vim_consistency",
    event = "VeryLazy"
  },
  {
    "jam1015/PushPop.vim",

    event = "VeryLazy",
    enabled = true,
    dependencies = { "vim-scripts/genutils" },
    config = function()
      require("plugin_keymaps").pushpop()
    end
  },
  { 'jam1015/vim-directional-help' },
  {
    'jam1015/nvim-smart-termsplit',
    config = function()
      require('nvim-smart-termsplit').setup()
      require('plugin_configs.nvim_smart_termsplit')
    end
  },
  {

    "jam1015/vim_consistency",
    event = "VeryLazy"
  },

  {

    "jam1015/vim_create_goto",
    --event = "VeryLazy",
    config = function()
      require("plugin_keymaps").vim_create_goto()
    end
  },
  {
    "folke/which-key.nvim",
    --event = "VeryLazy",
    opts = require("plugin_configs.which-key")
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = require("plugin_configs.flash"),
    config = function()
      require("plugin_keymaps").flash()
    end

  },
  {
    "gbprod/yanky.nvim",
    enabled = false,
    dependencies = {
      { "kkharji/sqlite.lua" }
    },
    config = function()
      require("plugin_keymaps").yanky()
      require("plugin_configs.yanky")
    end
  },
  { 'sainnhe/everforest', event = "VeryLazy" },
  { 'rose-pine/neovim',   name = "rose-pine" },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    branch = "main",
    config = function()
      require("plugin_configs.tokyonight")
    end,
    --
    --event = "VeryLazy"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    --event = "VeryLazy",
    enabled = true,
    config = function()
      require("plugin_configs.nvim-treesitter")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    cond = function() --also done vi autocmd in the cmp config
      return (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp")
    end,
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      { "onsails/lspkind.nvim",       event = "VeryLazy" },
      { "hrsh7th/cmp-nvim-lsp",       event = "VeryLazy" },
      { "R-nvim/cmp-r",               event = "VeryLazy" },
      { "hrsh7th/cmp-nvim-lua",       event = "VeryLazy" },
      { "hrsh7th/cmp-buffer",         event = "VeryLazy" },
      { "hrsh7th/cmp-path",           event = "VeryLazy" },
      { "hrsh7th/cmp-cmdline",        event = "VeryLazy" },
      { "kdheepak/cmp-latex-symbols", event = "VeryLazy" },
      {
        "L3MON4D3/LuaSnip", -- tag = "v<CurrentMajor>.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("plugin_configs.LuaSnip")
        end,

        event = "VeryLazy"
      },
      { "saadparwaiz1/cmp_luasnip", event = "VeryLazy" }
    },
    config = function()
      require("plugin_configs.nvim-cmp")
    end,
  },
  {
    "Rentib/cliff.nvim",
    keys = {
      { '<c-j>', mode = { 'n', 'v', 'o' }, function() require("cliff").go_down() end },
      { '<c-k>', mode = { 'n', 'v', 'o' }, function() require("cliff").go_up() end },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "VeryLazy" },
    dependencies = { "onsails/lspkind.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim"

    }, -- "RRethy/vim-illuminate" ,
    config = function()
      require("plugin_configs.lsp")
    end
  },


  {
    "ethanholz/nvim-lastplace",
    config = function() require("plugin_configs.nvim-lastplace") end
  },

  {
    'willothy/flatten.nvim',
    --event = "VeryLazy",

    --config = true,
    -- or pass configuration with
    --opts = require("plugin_configs.flatten"),
    opts = require("plugin_configs.flatten"),
    --priority = 1001,
    --commit = "07e9496191653587336b4c8f8cab02e5c34c7c44",
  },

  {
    'dhananjaylatkar/vim-gutentags',
    enabled = false,
    event = "VeryLazy",
    dependencies = { "dhananjaylatkar/cscope_maps.nvim", "skywind3000/gutentags_plus" },
    --event = "VeryLazy",


    config = function()
      require("plugin_configs.vim-gutentags")
    end
  },

  {
    "dzfrias/arena.nvim",
    event = "VeryLazy",
    -- Calls `.setup()` automatically
    config = function()
      require("plugin_configs.arena")
    end
    ,
  },
  {
    "dhananjaylatkar/cscope_maps.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/which-key.nvim",        -- optional [for whichkey hints]
      --"nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
      "ibhagwan/fzf-lua",            -- optional [for picker="fzf-lua"]
      "nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
    },
    opts = require("plugin_configs.cscope_maps.options")
    ,
    init = function()
      require("plugin_configs.cscope_maps.maps")
    end
  },
  {
    "linrongbin16/fzfx.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", 'junegunn/fzf' },

    -- specify version to avoid break changes
    --version = 'v5.*',

    config = function()
      require("plugin_configs.fzfx")
      require("plugin_keymaps").fzfx()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      "nvim-telescope/telescope-file-browser.nvim" },
    config = function()
      require("plugin_configs.telescope")
      require("plugin_keymaps").telescope()
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    --commit = "3d08501caef2329aba5121b753e903904088f7e6",
    config = function() require("plugin_configs.indent-blankline") end,
    event = "VeryLazy"
  },


  {
    "Tsuzat/NeoSolarized.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin_configs.neosolarized")
    end
  },


  {
    'pappasam/papercolor-theme-slim',
    event = "VeryLazy"
  },
  -- Using lazy.nvim
  {
    "cdmill/neomodern.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("neomodern").setup({
        -- optional configuration here
      })
    end,
  },
  {
    "navarasu/onedark.nvim",

    config = function()
      require("plugin_configs.onedark")
      --plugin_configs.nvim-notify
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function() require("plugin_configs.nvim-notify") end,
  },
  ---
  ("nvim-lua/plenary.nvim"),
  ("nvim-lua/popup.nvim"),

  {
    "airblade/vim-rooter",
    config = function()
      require("plugin_configs.vim-rooter")
      require("plugin_keymaps").vim_rooter()
    end
  },

  ({
    --"jeffkreeftmeijer/vim-numbertoggle",
    "sitiom/nvim-numbertoggle",
    enabled = true,
    --		lazy = true,
    --event = "VeryLazy",--{ "CursorMoved *", "CmdLineEnter *", "InsertEnter *" },
    init = function()
      require("plugin_configs.vim-numbertoggle_init")
    end,
  }),

  { 'famiu/bufdelete.nvim',     config = function() require("plugin_keymaps").bufdelete() end },
  { "mzlogin/vim-markdown-toc", ft = { "markdown", "md", }, },

  {
    "tpope/vim-unimpaired",
    event = "VeryLazy",
    config = function()
      require("plugin_keymaps").vim_unimpaired()
    end,
  },

  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-repeat",   event = "VeryLazy" },

  ({
    "lervag/vimtex",
    enabled = true,

    config = function()
      require("plugin_configs.vimtex")
    end,
  }),

  {
    "kana/vim-textobj-entire",
    event = "VeryLazy",
    dependencies = "kana/vim-textobj-user",
  },
  ({
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("plugin_configs.nvim-surround")
    end,
  }),



  { "bronson/vim-visual-star-search", event = "VeryLazy" },
  { "tpope/vim-repeat",               event = "VeryLazy" },



  ({
    "mattn/emmet-vim",
    event = "VeryLazy",
    init = function()
      require("plugin_configs.emmet-vim.initi")
    end,

    config = function()
      require("plugin_configs.emmet-vim.config")
    end,
    ft = { "js", "ts", "html", "htm", "tsx", "jsx", "md" },
  }),

  ({ -- run 'call firenvim#install(0)' to perhaps fix issues when it is not running in browser
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    --event = "VeryLazy",

    config = function()
      require("plugin_configs.firenvim")
    end,
  }),
  {
    "R-nvim/R.nvim",
    config = function()
      -- Create a table with the options to be passed to setup()
      local opts = {
        R_args = { "--quiet", "--no-save" },
        hook = {
          after_config = function()
            -- This function will be called at the FileType event
            -- of files supported by R.nvim. This is an
            -- opportunity to create mappings local to buffers.
            if vim.o.syntax ~= "rbrowser" then
              vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
              vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
            end
          end
        },
        min_editor_width = 72,
        rconsole_width = 78,
        disable_cmds = {
          "RClearConsole",
          "RCustomStart",
          "RSPlot",
          "RSaveClose",
        },
      }
      -- Check if the environment variable "R_AUTO_START" exists.
      -- If using fish shell, you could put in your config.fish:
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == "true" then
        opts.auto_start = 1
        opts.objbr_auto_start = true
      end
      require("r").setup(opts)
    end,
    lazy = false
  },
  ({
    "jalvesaq/Nvim-R", ft = { "R", "r", "rmd", "Rmd", "RMD" },
    enabled = false,
    branch = "stable",
    config = function()
      require("plugin_configs.Nvim-R")
    end,
  }),

  {
    "jbyuki/instant.nvim",
    enabled = false,
    config = function()
      require("plugin_configs.instant")
    end
  },
  { "equalsraf/neovim-gui-shim" },



  ({
    "phaazon/hop.nvim", event = "VeryLazy",
    config = function()
      require('plugin_configs.hop')
    end,
  }),

  {
    "andymass/vim-matchup",
    enabled = true,
    --event = { "VeryLazy" },
  },
  {
    "numToStr/Comment.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function() require("plugin_configs.Comment") end,
  },


  { 'windwp/nvim-ts-autotag',   enabled = true },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = false,
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    setup = function()
      require('plugin_configs.nvim-ts-context-commentstring')
    end
  },


  ------------------------------------------------------------------------------------------

  ({
    "folke/trouble.nvim", event = "VeryLazy",
    config = function()
      require("plugin_configs.trouble")
    end,
  }),

  { "lifecrisis/vim-difforig", event = "VeryLazy" },

  {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugin_configs.gitsigns") end,
    lazy = true
  },



  --"mfussenegger/nvim-dap",
  { 'jghauser/mkdir.nvim' },

  {
    "neoclide/coc.nvim",
    branch = "release",
    enabled = false,
    dependencies = { "neoclide/coc-snippets" },
    init = function()
      require("plugin_configs.coc")
    end,
    event = "VeryLazy",
  },


  {
    "yorik1984/newpaper.nvim",
    priority = 1000,
    config = function()
      require("newpaper").setup({
        style = "light"
      })
    end
  },



  {
    "gbprod/substitute.nvim",
    enabled = true,
    config = function()
      require("plugin_configs.substitute_nvim")
      require("plugin_keymaps").substitute_nvim()
    end
  },


  "powerman/vim-plugin-AnsiEsc",


  {
    'nvim-lualine/lualine.nvim',
    enabled = true,
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    init = function()
      require('plugin_configs.lualine.initi')
    end,
    config = function()
      require('plugin_configs.lualine.config')
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    init = function() vim.opt.termguicolors = true end,
    config = function() require('colorizer').setup() end
  },

  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    cmd = { "Browse" },
    init = function()
      require("plugin_configs.gx.initi")
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugin_configs.gx.config")
      require("plugin_keymaps").gx()
    end
  },

  {
    'stevearc/oil.nvim',
    config = function()
      require("plugin_configs.oil_nvim")
    end
  },
  {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    init = function() vim.opt.termguicolors = true end,
    config = function() require('colorizer').setup() end
  },

  --"mfussenegger/nvim-dap",
  {
    'echasnovski/mini.completion',
    version = "*",
    enabled = false,
    config = function()
      require('mini.completion').setup()
    end
  },
  { 'jghauser/mkdir.nvim' },


  { "svban/YankAssassin.vim", enabled = true },


  {
    "gbprod/substitute.nvim",
    enabled = true,
    config = function()
      require("plugin_configs.substitute_nvim")
      require("plugin_keymaps").substitute_nvim()
    end
  },

  {
    "powerman/vim-plugin-AnsiEsc",
  },
  {

    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    init = function()
      require('plugin_configs.lualine.initi')
    end,
    config = function()
      require('plugin_configs.lualine.config')
    end,

  },
  {
    'stevearc/quicker.nvim',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  {
    "mbbill/undotree",
    init = function()
      require("plugin_configs.undotree.initi")
    end,

    config = function()
      require("plugin_configs.undotree.config")
    end,
  },
  {

    "https://gitlab.com/yorickpeterse/vim-paper.git",
  },
  {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    init = function() vim.opt.termguicolors = true end,
    config = function() require('colorizer').setup() end
  },
  {
    'Shatur/neovim-session-manager',
    enabled = false
  },
  {

    'jam1015/winshift.nvim',
    enabled = true,
    --dir = "~/Documents/vim_plugins/winshift.nvim",
    branch = "my_merged_rough",
    config = function()
      require("plugin_configs.winshift")
      require("plugin_keymaps").nvim_winshift()
    end
  },
  {

    "jam1015/nvim-window",
    branch = "only_uppercase",
    enabled = true,
    config = function()
      require("plugin_configs.nvim_window")
      require("plugin_keymaps").nvim_window()
      return true
    end,
  },
  {

    'FluxxField/bionic-reading.nvim',
    config = function()
      require('plugin_configs.bionic-reading')
    end,

  },
  {
    'JellyApple102/easyread.nvim',
    enabled = false,
    config = function()
      require('plugin_configs.easyread')
    end,

  },
  {

    "kwkarlwang/bufjump.nvim",
    dependencies = {
      "folke/which-key.nvim", -- optional [for whichkey hints]
    },
    config = function()
      require("plugin_configs.bufjump")
    end,

  },


  --
  --  ------------- disabled ----------
  --
  --  {
  --    'nvim-tree/nvim-tree.lua',
  --    enabled = false,
  --    event = "VeryLazy",
  --    config = function()
  --      require("plugin_configs.nvim-tree")
  --      require("plugin_keymaps").nvim_tree()
  --    end
  --
  --
  --  },
  --
  --  {
  --    'ggandor/leap-ast.nvim',
  --    -- right now prefer treehopper because it gives more hints
  --    config = function() require("plugin_keymaps").leap_ast() end,
  --    enabled = false,
  --
  --  },
  --  {
  --    "mfussenegger/nvim-treehopper",
  --    enabled = true,
  --    event = "VeryLazy",
  --    dependencies = "phaazon/hop.nvim",
  --    config = function() require("plugin_configs.nvim-treehopper") end,
  --  },
  --  {
  --    'altermo/nxwm',
  --    enabled = false,
  --    branch = 'x11',
  --    config = function()
  --      require('plugin_configs.nxwm')
  --    end
  --  },
  --  {
  --    -- startup screen
  --    "goolord/alpha-nvim",
  --    enabled = false,
  --    cond = require("plugin_configs.alpha-nvim.cond"),
  --    config = function()
  --      require("plugin_configs.alpha-nvim.config")
  --    end,
  --
  --  },
  --  ({
  --    "neoclide/coc.nvim",
  --    branch = "release",
  --    enabled = false,
  --    dependencies = { "neoclide/coc-snippets" },
  --    init = function()
  --      require("plugin_configs.coc")
  --    end,
  --    event = "VeryLazy",
  --  }),
  --
  --  { "tpope/vim-scriptease", enabled = false }, -- messes with s mapping of leap
  --
  --  {
  --    "josa42/nvim-gx",
  --    enabled = false,
  --    config = function()
  --      vim.keymap.set('n', 'gx', require('gx').gx)
  --    end
  --  },
}
