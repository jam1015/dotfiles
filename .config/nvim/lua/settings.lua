local set = vim.opt

vim.cmd([[ highlight Comment cterm=italic gui=italic]])
vim.g.debug = false

set.bg = "dark"
local colorscheme = "tokyonight"
if os.getenv("DISPLAY") then
	local status_ok = nil
	status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

	if not status_ok then
		vim.cmd([[colorscheme elflord]])
	end
else
	vim.cmd([[colorscheme elflord]])
end
-- add complete/completeopt
set.modeline = false
set.completeopt = 'menu,menuone,noselect'
set.shortmess = "IFw"
set.hlsearch = true
set.mouse = "a"
set.undofile = true --persistent undo
set.gdefault = true
set.nrformats = set.nrformats - 'octal'
set.formatoptions = set.formatoptions - 'cro'
local noCRO = vim.api.nvim_create_augroup("no_cro", { clear = true }) --disables automatic comments
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
	group = noCRO,
})
set.history = 2000
set.autoread = true
set.scrolloff = 3   -- show a few lines around cursor
set.display = "lastline"
set.shiftwidth = 4  --how much indentation from >
set.softtabstop = 4 --lets us delete by tabs when expandtab is on
set.tabstop = 4
--set.path = set.path + "**"
set.expandtab = false
set.smarttab = false
set.cindent = false
set.smartindent = false
set.wildmenu = true
set.wildmode = 'longest:full,full'
set.wildignorecase = true
set.wildignore = '*.git/*,*.tags,tags,*.o,*.class,*.ccls-cache'
set.ignorecase = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.list = true
set.listchars = ''
set.listchars = set.listchars + 'trail:␣'
set.listchars = set.listchars + 'lead:·'
set.listchars = set.listchars + 'extends:»'
set.listchars = set.listchars + 'precedes:«'
set.listchars = set.listchars + 'tab:   '
set.listchars = set.listchars + 'nbsp:⣿'
set.number = true
set.relativenumber = true
set.equalalways = false
set.spelllang = "en_us"
set.termguicolors = true

set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldlevelstart = 99

if os.getenv("DISPLAY") then
	--if not os.getenv("SSH_CONNECTION") then
	set.clipboard = 'unnamedplus'
	--end
else
end

vim.g.vim_json_syntax_conceal = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.c_comment_strings = 1 --can be any value
set.pumheight = 10
set.inccommand = 'split'
set.shada = "'1000,%"




local function setup_tmux_clipboard()
	local tmux = os.getenv("TMUX")
	if tmux then
		-- Configure Neovim to use tmux's clipboard
		vim.cmd([[
		let g:clipboard = {
			\   'name': 'myClipboard',
			\   'copy': {
				\      '+': ['tmux', 'load-buffer', '-w', '-'],
				\      '*': ['tmux', 'load-buffer', '-w', '-'],
				\    },
				\   'paste': {
					\      '+': ['tmux', 'save-buffer', '-'],
					\      '*': ['tmux', 'save-buffer', '-'],
					\   },
					\   'cache_enabled': 0,
					\ }

					]])
	else
		return true
	end
end

-- Call the function to set up the clipboard
setup_tmux_clipboard()


