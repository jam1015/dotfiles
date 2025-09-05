return
  {
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      config = function() require("plugin_configs.which-key") end
    },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "onsails/lspkind.nvim",
        {
          "williamboman/mason.nvim",
          dependencies = { "Zeioth/mason-extra-cmds" },
          cmd = {
            "Mason",
            "MasonInstall",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonLog",
            "MasonUpdate",
            "MasonUpdateAll"
          }
        },
        "williamboman/mason-lspconfig.nvim",
        "folke/neodev.nvim",
        {
          "folke/which-key.nvim",
          event = "VeryLazy",
          opts = {},
          config = function() require("plugin_configs.which-key") end
        },
      }, -- "RRethy/vim-illuminate" ,
      config = function()
        require("plugin_configs.lsp")
      end
    },
    {
      'stevearc/oil.nvim',
      config = function()
        -- your existing oil setup
        require("plugin_configs.oil_nvim")
        require("plugin_keymaps").oil()
      end,
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = require("plugin_configs.flash"),
      keys = require("plugin_keymaps").flash()
    },
    {
      'jam1015/bluloco.nvim',
      --dir = "~/bluloco.nvim",
      --lazy = false,
      --priority = 1000,
      dependencies = { 'rktjmp/lush.nvim' },
      config = function()
        require("plugin_configs.bluloco")
      end,
    },
    { "ellisonleao/gruvbox.nvim", config = function() require("plugin_configs.gruvbox") end },
    {
      "rcarriga/nvim-notify",
      event = "VeryLazy",
      config = function() require("plugin_configs.nvim-notify") end,
    },
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugin_configs.harpoon")
      end,

    },
    {
      "samjwill/nvim-unception",
      init = function()
        -- Optional settings go here!
        -- e.g.) vim.g.unception_open_buffer_in_new_tab = true
      end
    },

    "tuurep/registereditor",
    {


      "chentoast/marks.nvim",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.marks")
      end
    },


    {
      'jam1015/nvim_gui_termquit',
      --init = function() require("term_autocmds") end,
      cond = function() return vim.fn.has("gui_running") == 1 end,
      --dir = "~/vim_plugins/nvim_gui_termquit",
      config = function()
        require("plugin_configs.nvim_gui_termquit")
        require("plugin_keymaps").nvim_gui_termquit()
      end,
      dependencies = {
        "samjwill/nvim-unception",
        "sitiom/nvim-numbertoggle",
      },
    },

    'vuciv/golf',


    {
      "jam1015/create-lua-module",
      config = function() require("create-lua-module") end,
      dependencies = { "jghauser/mkdir.nvim" }
    },

    {
      "zaldih/themery.nvim",
      lazy = false,
      config = function()
        -- Minimal config
        require("themery").setup({
          themes = { "paper", "tokyonight", }, -- Your list of installed colorschemes.
          livePreview = true,                  -- Apply theme while picking. Default to true.
        })
        --require("plugin_configs.themery")
      end
    },
    {
      "oskarrrrrrr/symbols.nvim",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.symbols")
      end
    },

    {
      'FluxxField/bionic-reading.nvim',
      event = "VeryLazy",
      config = function()
        require('plugin_configs.bionic-reading')
      end,
    },

    {
      'maxbrunsfeld/vim-yankstack',
      event = "VeryLazy",
      init = function()
        require("plugin_configs.yankstack.initi")
      end,

      config = function()
        require("plugin_keymaps").yankstack()
      end

    },
    {
      "ilof2/posterpole.nvim",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.posterpole")
      end
    },
    {
      'bettervim/yugen.nvim',
      event = "VeryLazy",
    },
    {
      'gcmt/vessel.nvim',
      event = "VeryLazy",
      config = function()
        require("plugin_configs.vessel")
      end
    },
    {
      "folke/lazydev.nvim",
      --event = "VeryLazy",
      ft = "lua",                                   -- only load on lua files
      opts = require("plugin_configs.lazydev_nvim") --enabled = false

    },
    { "Bilal2453/luvit-meta",     lazy = true,                                              event = "VeryLazy" }, -- optional `vim.uv` typings
    {
      "leath-dub/snipe.nvim",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.snipe")
        require("plugin_keymaps").snipe()
      end
    },





    {
      "jaimecgomezz/here.term",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.hereterm")
        require("plugin_keymaps").hereterm()
      end
    },
    {
      'jam1015/winshift.nvim',
      event = "VeryLazy",
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
      event = "VeryLazy",
      config = function()
        require("plugin_configs.nvim_window")
        require("plugin_keymaps").nvim_window()
        return true
      end,
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
      "jam1015/PushPop.vim",

      event = "VeryLazy",
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
      event = "VeryLazy",
      config = function()
        require("plugin_keymaps").vim_create_goto()
      end
    },

    { "meznaric/key-analyzer.nvim",  enabled = false, opts = {} },
    {
      "jam1015/YankAssassin.nvim",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.YankAssasin")
      end,
    },
    --{
    --  "gbprod/yanky.nvim",
    --  dependencies = {
    --    { "kkharji/sqlite.lua" }
    --  },
    --  config = function()
    --    require("plugin_keymaps").yanky()
    --    require("plugin_configs.yanky")
    --  end
    --},
    { 'sainnhe/everforest', event = "VeryLazy" },
    { 'rose-pine/neovim',   name = "rose-pine" },
    {
      "folke/tokyonight.nvim",
      priority = 1000,
      branch = "main",
      config = function()
        require("plugin_configs.tokyonight")
      end,
      --event = "VeryLazy"
    },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "VeryLazy",
      enabled = true,
      config = function()
        require("plugin_configs.nvim-treesitter")
      end,
    },

    {
      "PaterJason/cmp-conjure",
      enabled = false,
      lazy = true,
      config = function()
        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, { name = "conjure" })
        return cmp.setup(config)
      end,
    },

    {
      --"hrsh7th/nvim-cmp",
      "iguanacucumber/magazine.nvim",
      event = "VeryLazy",
      name = "nvim-cmp",
      cond = function() --also done vi autocmd in the cmp config
        return (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp")
      end,
      dependencies = {
        { "PaterJason/cmp-conjure",     event = "VeryLazy" },
        { "onsails/lspkind.nvim",       event = "VeryLazy" },
        { "R-nvim/cmp-r",               event = "VeryLazy" },
        { "hrsh7th/cmp-nvim-lua",       event = "VeryLazy" },
        { "hrsh7th/cmp-nvim-lsp",       event = "VeryLazy" },
        { "hrsh7th/cmp-buffer",         event = "VeryLazy" },
        { "hrsh7th/cmp-path",           event = "VeryLazy" },
        { "hrsh7th/cmp-cmdline",        event = "VeryLazy" },
        { "kdheepak/cmp-latex-symbols", event = "VeryLazy" },

        {
          "L3MON4D3/LuaSnip", -- tag = "v<CurrentMajor>.*",
          event = "VeryLazy",
          build = "make install_jsregexp",
          dependencies = { "rafamadriz/friendly-snippets" },
          config = function()
            require("plugin_configs.LuaSnip")
          end,

        },
        { "saadparwaiz1/cmp_luasnip", event = "VeryLazy" }
      },
      config = function()
        require("plugin_configs.nvim-cmp")
      end,
    },
    {
      'aaronik/treewalker.nvim',
      event = "VeryLazy",

      -- The following options are the defaults.
      -- Treewalker aims for sane defaults, so these are each individually optional,
      -- and setup() does not need to be called, so the whole opts block is optional as well.
      opts = require("plugin_configs.treewalker"),
      config = function()
        require("plugin_keymaps").treewalker()
      end
    },


    {
      "ethanholz/nvim-lastplace",
      --event = "VeryLazy",
      config = function() require("plugin_configs.nvim-lastplace") end
    },


    {
      'skywind3000/gutentags_plus',
      event = "VeryLazy",
      dependencies = { "dhananjaylatkar/cscope_maps.nvim", 'dhananjaylatkar/vim-gutentags' },
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
      'dnlhc/glance.nvim',
      config = function()
        require('plugin_keymaps').glance()
      end,
      event = 'VeryLazy',
      cmd = 'Glance'
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
      'maxmx03/solarized.nvim',
      config = function()
        require("plugin_configs.solarized")
      end,
    },

    {
      'pappasam/papercolor-theme-slim',
      event = "VeryLazy"
    },
    -- Using lazy.nvim
    {
      "cdmill/neomodern.nvim",
      event = "VeryLazy",
      priority = 1000,
      config = function()
        require("plugin_configs.neomodern")
      end,
    },
    {
      "navarasu/onedark.nvim",
      event = "VeryLazy",

      config = function()
        require("plugin_configs.onedark")
        --plugin_configs.nvim-notify
      end,
    },
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
    {
      "blanktiger/aqf.nvim",
      event = "VeryLazy",
      config = function()
        require("aqf").setup()
        local telescope = require("telescope")
        telescope.load_extension("aqf")
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      }
    },
    {
      'famiu/bufdelete.nvim',
      config = function() require("plugin_keymaps").bufdelete() end,
      event = "VeryLazy",
    },
    { "mzlogin/vim-markdown-toc", ft = { "markdown", "md", }, },

    {
      "tummetott/unimpaired.nvim",
      enabled = true,
      event = "VeryLazy",
      config = function()
        require("plugin_keymaps").unimpaired()
      end,
    },

    {
      'echasnovski/mini.ai',
      event = "VeryLazy",
      version = false,
      config = function()
        require("plugin_configs.miniai")
      end
    },




    ({
      "lervag/vimtex",
      config = function()
        require("plugin_configs.vimtex")
        require("plugin_keymaps").vimtex()
      end,
    }),

    {
      "kana/vim-textobj-entire",
      event = "VeryLazy",
      dependencies = "kana/vim-textobj-user",
    },

    { "tpope/vim-repeat",         event = "VeryLazy" },


    ({
      "mattn/emmet-vim",
      event = "VeryLazy",
      init = function()
        require("plugin_keymaps").emmet_vim("initi")
      end,

      config = function()
        require("plugin_keymaps").emmet_vim("config")
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
      event = "VeryLazy",
      config = function() require('plugin_configs.rnvim') end,
    },

    {
      "jbyuki/instant.nvim",
      enabled = false,
      config = function()
        require("plugin_configs.instant")
      end
    },


    ({
      "smoka7/hop.nvim",
      event = "VeryLazy",
      config = function()
        require('plugin_configs.hop')
        require('plugin_keymaps').hop()
      end,
    }),

    {
      "andymass/vim-matchup",
      --event = "VeryLazy", event = { "VeryLazy" },
    },
    {
      "numToStr/Comment.nvim",
      enabled = true,
      event = "VeryLazy",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = function() require("plugin_configs.Comment") end,
    },


    { 'windwp/nvim-ts-autotag', enabled = true,    event = "VeryLazy", },
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
      "folke/trouble.nvim",
      event = "VeryLazy",
      opts = require("plugin_configs.trouble")
    }),

    { "jam1015/vim-difforig",   event = "VeryLazy" },

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
      event = "VeryLazy",
    },

    {
      "gbprod/substitute.nvim",
      event = "VeryLazy",
      config = function()
        require("plugin_configs.substitute_nvim")
        require("plugin_keymaps").substitute_nvim()
      end
    },


    -- ;"powerman/vim-plugin-AnsiEsc",


    {
      'nvim-lualine/lualine.nvim',
      --event = "VeryLazy",
      dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
      init = function()
        require('plugin_configs.lualine.initi')
      end,
      config = function()
        --require('lualine').setup({})
        require('plugin_configs.lualine.config')
      end,
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


    {
      'zenbones-theme/zenbones.nvim',
      dependencies = "rktjmp/lush.nvim",
    },


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
      "mbbill/undotree",
      event = "VeryLazy",
      init = function()
        require("plugin_configs.undotree.initi")
      end,

      config = function()
        require("plugin_configs.undotree.config")
      end,
    },
    {

      "yorickpeterse/vim-paper",
      event = "VeryLazy",
    },


    {
      'JellyApple102/easyread.nvim',
      enabled = false,
      config = function()
        require('plugin_configs.easyread')
      end,

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
      "norcalli/nvim-colorizer.lua",
      enabled = false,
      init = function() vim.opt.termguicolors = true end,
      config = function() require('colorizer').setup() end
    },

    {

      "kwkarlwang/bufjump.nvim",
      event = "VeryLazy",
      dependencies = {
        "folke/which-key.nvim", -- optional [for whichkey hints]
      },
      config = function()
        require("plugin_configs.bufjump")
      end,

    },

    {
      "jpalardy/vim-slime",
      --event = "VeryLazy",
      init = function()
        require("plugin_configs.vim-slime.initi")
      end,

      config = function()
        require("plugin_configs.vim-slime.config")
      end,
    },

    {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("plugin_configs.nvim-surround")
      end

    },

    {
      "Olical/conjure",
      enabled = false,
      ft = { "clojure", "fennel", "scm" }, -- etc
      event = "VeryLazy",
      init = function()
        -- Set configuration options here
        -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
        -- This is VERY helpful when reporting an issue with the project
        -- vim.g["conjure#debug"] = true
      end,

      -- Optional cmp-conjure integration
      dependencies = { "PaterJason/cmp-conjure" },
    },




    -- to add: bqf

  }
