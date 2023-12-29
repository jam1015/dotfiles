local os_name = vim.loop.os_uname().sysname
local lisp_lazy = function() --also done vi autocmd in the cmp config
	if (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp") then
		return false
	else
		return true
	end
end

return {


	({
		"hrsh7th/nvim-cmp",
		enabled = true,
		cond = function() --also done vi autocmd in the cmp config
			return (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp")
		end,
		lazy = true,
		event = "VeryLazy",
		dependencies = {
			{ "onsails/lspkind.nvim", event = "VeryLazy" },
			{ "hrsh7th/cmp-nvim-lsp", event = "VeryLazy" },
			{ "hrsh7th/cmp-nvim-lua", event = "VeryLazy" },
			{ "hrsh7th/cmp-buffer",   event = "VeryLazy" },
			{ "hrsh7th/cmp-path",     event = "VeryLazy" },
			{ "hrsh7th/cmp-cmdline",  event = "VeryLazy" },
			{
				"L3MON4D3/LuaSnip", -- tag = "v<CurrentMajor>.*",
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
	}),


	{
		"example/example",
		dir = "~/Documents/example",
		config = function()
			vim.api.nvim_exec_autocmds("FileType", {})
		end



	},
	{
		"neovim/nvim-lspconfig",
		event = { "VeryLazy" },
		dependencies = { "onsails/lspkind.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim"

		}, -- "RRethy/vim-illuminate" },
		config = function()
			require("plugin_configs.lsp")
		end
	},

	{
		"ggandor/flit.nvim",

		event = "VeryLazy",

		--commit = "5c9a78b97f7f4301473ea5e37501b5b1d4da167b",
		config = function() require("plugin_configs.flit") end
	},

	({
		"ggandor/leap.nvim",
		event = "VeryLazy",
		--commit ="8facf2eb6a378fd7691dce8c8a7b2726823e2408",
		config = function()
			require('plugin_configs.leap')
		end,
	}),
	({ "ethanholz/nvim-lastplace",
		config = function() require("plugin_configs.nvim-lastplace") end }),

	{
		'willothy/flatten.nvim',
		event = "VeryLazy",

		--config = true,
		-- or pass configuration with
		--opts = require("plugin_configs.flatten"),
		opts = require("plugin_configs.flatten"),
		lazy = false,
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
			"folke/which-key.nvim", -- optional [for whichkey hints]
			--"nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
			"ibhagwan/fzf-lua",   -- optional [for picker="fzf-lua"]
			"nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
		},
		opts = require("plugin_configs.cscope_maps.options")
		,
		init = function()
			require("plugin_configs.cscope_maps.maps")
		end
	},
	--
	({ "ibhagwan/fzf-lua", event = "VeryLazy", config = function() require('plugin_configs.fzf-lua') end }),

	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		enabled = false,
		dependencies = { "nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = (function()
					if os_name == "Darwin" then
						-- macOS specific value
						return "make"
					elseif os_name == "Linux" then
						-- Linux specific value
						return
						"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
					else
						return
						"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
					end
				end)()
			},
			"nvim-telescope/telescope-file-browser.nvim" },
		config = function()
			require("plugin_configs.telescope")
		end
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		--commit = "9637670896b68805430e2f72cf5d16be5b97a22a",
		config = function() require("plugin_configs.indent-blankline") end,
		event = "VeryLazy"
	},
	{
		"dzfrias/arena.nvim",
		event = "BufWinEnter",
		-- Calls `.setup()` automatically
		config = true,
	},


	{
		"Tsuzat/NeoSolarized.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin_configs.neosolarized")
		end
	},

	({
		"folke/tokyonight.nvim",
		priority = 1000,
		branch = "main",
		config = function()
			require("plugin_configs.tokyonight")
		end,
		--
		--event = "VeryLazy"
	}),

	{
		'pappasam/papercolor-theme-slim'
	},

	{
		"navarasu/onedark.nvim",

		config = function()
			require("plugin_configs.onedark")
			--plugin_configs.nvim-notify
		end,
		event = "VeryLazy"
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
			require("plugin_keymaps").pluginKeymaps("vim-rooter")
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
		"vlime/vlime", --install quicklisp on your system when you install this; do it manually rather than through a package manager, or find where the package manager installs the proper lisp script
		enabled = false,

		event = "VeryLazy",
		dependencies = "kovisoft/paredit",
		config = function()
			require("plugin_configs.vlime")
		end
	},
	{ 'famiu/bufdelete.nvim',     config = function() require("plugin_keymaps").pluginKeymaps("bufdelete.nvim") end },
	{ "mzlogin/vim-markdown-toc", ft = { "markdown", "md", }, },

	{
		"tpope/vim-unimpaired",
		event = "VeryLazy",
		config = function()
			require("plugin_keymaps").pluginKeymaps("vim-unimpaired")
		end,
	},

	{ "tpope/vim-fugitive",   event = "VeryLazy" },
	{ "tpope/vim-scriptease", enabled = false }, -- messes with s mapping of leap
	{
		"windwp/nvim-autopairs",
		enabled = false,
		event = "VeryLazy",
		config = function() require("plugin_configs.nvim-autopairs") end
	},

	({
		"lervag/vimtex",
		enabled = true,
		--event = "VeryLazy",

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


	({
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin_configs.which-key")
		end,
	}),

	{ "bronson/vim-visual-star-search", event = "VeryLazy" },
	{ "tpope/vim-repeat",               event = "VeryLazy" },
	{ "qpkorr/vim-bufkill",             event = "VeryLazy", enabled = false },
	{ "kevinoid/vim-jsonc",             event = "VeryLazy" },


	{
		"jam1015/PushPop.vim",

		event = "VeryLazy",
		enabled = true,
		dependencies = { "vim-scripts/genutils" },
		config = function()
			require("plugin_keymaps").pluginKeymaps("PushPop.vim")
		end
	},

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
		event = { "VeryLazy" },
	},
	{
		"numToStr/Comment.nvim",
		enabled = false,
		event = "VeryLazy",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function() require("plugin_configs.Comment") end,
	},

	{
		"mfussenegger/nvim-treehopper",
		event = "VeryLazy",
		dependencies = "phaazon/hop.nvim",
		config = function() require("plugin_configs.nvim-treehopper") end,
	},

	({
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		enabled = true,
		config = function()
			require("plugin_configs.nvim-treesitter")
		end,
	}),
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		enabled = false,
		event = "VeryLazy",
		dependencies = "nvim-treesitter/nvim-treesitter"
	},


	------------------------------------------------------------------------------------------

	({
		"folke/trouble.nvim", event = "VeryLazy",
		config = function()
			require("plugin_configs.trouble")
		end,
	}),

	{ "lifecrisis/vim-difforig",  event = "VeryLazy" },

	{
		"lewis6991/gitsigns.nvim",
		config = function() require("plugin_configs.gitsigns") end,
		lazy = true
	},

	{
		'nvim-tree/nvim-tree.lua',
		event = "VeryLazy",
		tag = 'nightly', -- optional, updated every week. (see issue #1193)
		config = function()
			require("plugin_configs.nvim-tree")
			require("plugin_keymaps").pluginKeymaps("nvim-tree")
		end


	},











--"mfussenegger/nvim-dap",
	{
		'echasnovski/mini.completion',
		version = "*",
		enabled = false,
		config = function()
			require('mini.completion')
				.setup()
		end
	},
	{ 'jghauser/mkdir.nvim' },

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

	{
		"gbprod/yanky.nvim",
		enabled = false,

		--enabled = function()
		--	return not os.getenv("DISPLAY")
		--end,

		event = "VeryLazy",
		--branch = "autocmd",
		--dependencies = { "kkharji/sqlite.lua", },

		--dir = "/home/jordan/Documents/yanky.nvim",
		config = function()
			require("plugin_configs.yanky")
			require("plugin_keymaps").pluginKeymaps("yanky.nvim")
		end


	},
	{ "svban/YankAssassin.vim", enabled = true },
	{
		-- does the same thing as YankRing
		'maxbrunsfeld/vim-yankstack',
		--event = "VeryLazy",
		--dir = "~/Documents/vim-yankstack",

		enabled = true,

		--		enabled = function()
		--			return os.getenv("DISPLAY")
		--		end,

		init = function()
			require("plugin_configs.vim-yankstack.initi")
		end,
		config = function()
			require("plugin_configs.vim-yankstack.config")
			require("plugin_keymaps").pluginKeymaps("vim-yankstack")
		end
	},



	{
		"gbprod/substitute.nvim",
		enabled = true,
		config = function()
			require("plugin_configs.substitute_nvim")
			require("plugin_keymaps").pluginKeymaps("substitute_nvim")
		end
	},


	"powerman/vim-plugin-AnsiEsc",

	{

		"jam1015/vim_consistency",
		event = "VeryLazy"
	},

	{

		"jam1015/vim_create_goto",
		dir = "~/Documents/vim_create_goto",
		event = "VeryLazy",
		config = function()
			require("plugin_keymaps").pluginKeymaps("vim_create_goto")
		end
	},

	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('plugin_configs.lualine')
		end,
	},

	({
		--"jpalardy/vim-slime",
		"jam1015/vim-slime",
		dir = "~/Documents/slimes/vim-slime",
		--branch = "vim_array", --"main",--
		--event = "VeryLazy",
		init = function()
			require("plugin_configs.vim-slime.initi")
		end,

		config = function()
			require("plugin_configs.vim-slime.config")
		end,
	}),




	{
		"norcalli/nvim-colorizer.lua",
		enabled = false,
		init = function() vim.opt.termguicolors = true end,
		config = function() require('colorizer').setup() end
	},






}
