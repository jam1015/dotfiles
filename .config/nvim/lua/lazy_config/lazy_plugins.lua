local lisp_lazy = function() --also done vi autocmd in the cmp config
	if (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp") then
		return false
	else
		return true
	end
end

return {
	{
		'willothy/flatten.nvim',
		config = true,
		-- or pass configuration with
		opts = require("plugin_configs.flatten")
	},

	{
		'ludovicchabant/vim-gutentags',

		config = function()
			require("plugin_configs.vim-gutentags")
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function() require("plugin_configs.indent-blankline") end,
		event = "VeryLazy"
	},
	"overcache/NeoSolarized",
	({
		"folke/tokyonight.nvim",
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

	({
		"ellisonleao/gruvbox.nvim", event = "VeryLazy"
	}),
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function() require("plugin_configs.nvim-notify") end,
	},
	---
	{
		'dstein64/vim-startuptime',
		enabled = true,
		event = "VeryLazy",
		config = function() require("plugin_configs/vim-startuptime") end
	},
	("nvim-lua/plenary.nvim"),
	("nvim-lua/popup.nvim"),
	({ "ethanholz/nvim-lastplace",
		config = function() require("plugin_configs.nvim-lastplace") end }),

	{
		"airblade/vim-rooter",
		config = function()
			require("plugin_configs.vim-rooter")
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
			vim.cmd([[]])
		end
	},
	{ 'famiu/bufdelete.nvim',     config = function() require("plugin_keymaps").pluginKeymaps("bufdelete.nvim") end },
	{ "mzlogin/vim-markdown-toc", ft = { "markdown", "md", }, },
	{
		"tpope/vim-unimpaired",
		"tpope/vim-fugitive",
		config = function()
			require("plugin_keymaps").pluginKeymaps("vim-unimpaired")
		end,
		event = "VeryLazy"
	},

	"tpope/vim-scriptease",
	{
		"windwp/nvim-autopairs",
		enabled = false,
		event = "VeryLazy",
		config = function() require("plugin_configs.nvim-autopairs") end
	},

	({
		"lervag/vimtex",
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
		"kylechui/nvim-surround", event = "VeryLazy",
		config = function()
			require("plugin_configs.nvim-surround")
		end,
	}),


	({
		"folke/which-key.nvim", event = "VeryLazy",
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
		"mattn/emmet-vim", event = "VeryLazy",
		lazy = true,
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

	({ "ibhagwan/fzf-lua", event = "VeryLazy" }),

	({
		"nvim-telescope/telescope.nvim", event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build =
				'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
			},
			"nvim-telescope/telescope-file-browser.nvim" },
		config = function()
			require("plugin_configs.telescope")
		end
	}),

	({
		"phaazon/hop.nvim", event = "VeryLazy",
		disable = true,
		config = function()
			require('plugin_configs.hop')
		end,
	}),

	{
		"ggandor/flit.nvim",

		--event = "VeryLazy",

		--commit = "be110f9814a45788d10537fd59b3c76d956bb7ad",
		config = function() require("plugin_configs.flit") end
	},
	({
		"ggandor/leap.nvim",
		--event = "VeryLazy",
		--commit ="9cc411481db859059ad66c8ad844b9386dc62d5c",
		config = function()
			require('plugin_configs.leap')
		end,
	}),


	{
		"andymass/vim-matchup",
		enabled = true,
			event = { "VeryLazy" },
	},
	{
		"numToStr/Comment.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function() require("plugin_configs.Comment") end,
	},

	({
		"nvim-treesitter/nvim-treesitter", event = "BufWinEnter",
		enabled = true,
		--event = "VeryLazy",
		config = function()
			require("plugin_configs.nvim-treesitter")
		end,
	}),
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy", dependencies = "nvim-treesitter/nvim-treesitter" },
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
	{
		'nvim-tree/nvim-tree.lua',
		event = "VeryLazy",
		dependencies = {
		},
		tag = 'nightly', -- optional, updated every week. (see issue #1193)
		config = function() require("plugin_configs.nvim-tree") end

	},



	{
		"neovim/nvim-lspconfig",
		enabled = true,
		event = { "VeryLazy" },
		--	lazy = true,
		--						event = {"InsertEnter"}
		--
		--event = { "BufReadPre", "BufNewFile", "BufRead" },

		dependencies = { "onsails/lspkind.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim"

		}, -- "RRethy/vim-illuminate" },
		config = function()
			require("plugin_configs.lsp")
		end
	},
	--"mfussenegger/nvim-dap",

	({
		"hrsh7th/nvim-cmp",
		cond = function() --also done vi autocmd in the cmp config
			return (vim.bo.filetype ~= "lisp" and vim.bo.filetype ~= "el" and vim.bo.filetype ~= "elisp")
		end,
		enabled = true,
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
		-- does the same thing as vim-yankstack
		"vim-scripts/YankRing.vim",
		enabled = function()
			return os.getenv("DISPLAY")
		end
		--event = "VeryLazy"
	},
	{
		-- does the same thing as YankRing
		'maxbrunsfeld/vim-yankstack',
		enabled = false,
		init = function()
			require("plugin_configs.vim-yankstack")
		end,
		config = function()
			require("plugin_configs.vim-yankstack.config")
			require("plugin_keymaps").pluginKeymaps("vim-yankstack")
		end
	},

	{
		"gbprod/yanky.nvim",
		enabled = function()
			return not os.getenv("DISPLAY")
		end,

		--event = {"TextYankPost","CursorMoved","CursorHold"},
		event = "VeryLazy", --{"CursorMoved", "VeryLazy","VimEnter" },
		--branch = "autocmd",
		dependencies = { "kkharji/sqlite.lua", },

		--dir = "/home/jordan/Documents/yanky.nvim",
		config = function()
			require("plugin_configs.yanky")
		end


	},

	({
		"jpalardy/vim-slime",
		branch = "vim_array", --"main",--
		event = "VeryLazy",
		enabled = false,
		init = function()
			require("plugin_configs.vim-slime.initi")
		end,

		config = function()
			require("plugin_configs.vim-slime.config")
		end,
	}),

	({
		"jam1015/vim-slime-ext-neovim",
		branch = "status_override",
		--dir= "~/Documents/vim-slime-ext-neovim",
		--"main",--
		--event = "VeryLazy",
		dependencies = { "jpalardy/vim-slime-ext-plugins", },

		init = function()
			require("plugin_configs.vim-slime-ext-plugins.initi")
		end,

		config = function()
			require("plugin_configs.vim-slime-ext-plugins.config")
		end,
	}),
	{
		"norcalli/nvim-colorizer.lua",
		enabled = false,
		init = function() vim.opt.termguicolors = true end,
		config = function() require('colorizer').setup() end
	},
	"powerman/vim-plugin-AnsiEsc"
}
