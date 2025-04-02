vim.g.loaded_gtags_cscope = 1
local set = vim.opt
vim.cmd([[ highlight Comment cterm=italic gui=italic]])
vim.g.debug = false

set.bg = "light"
local colorscheme = "gruvbox"
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
set.shortmess = "Fw"
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
set.hidden = true
set.autoread = true
set.scrolloff = 3   -- show a few lines around cursor
set.display = "lastline"
set.shiftwidth = 2  --how much indentation from >
set.softtabstop = 2 --lets us delete by tabs when expandtab is on
set.tabstop = 2
set.showcmd = false
--set.path = set.path + "**"
set.expandtab = true
set.smarttab = false
set.cindent = false
set.smartindent = false
set.wildmenu = true
set.wildmode = 'longest:full,full'
set.wildignorecase = true
set.wildignore = '*.git/*,*.tags,tags,*.o,*.class,*.ccls-cache'
set.wildoptions = "fuzzy,pum,tagfile"
set.ignorecase = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.list = true
set.listchars = ''
set.listchars = set.listchars + 'trail:␣'
set.listchars = set.listchars + 'extends:»'
set.listchars = set.listchars + 'precedes:«'
set.listchars = set.listchars + 'tab:│  '
set.listchars = set.listchars + 'nbsp:⣿'
set.number = true
set.relativenumber = true
set.equalalways = false
set.spelllang = "en-custom"
if os.getenv("DISPLAY") then
  set.termguicolors = true
else
end
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldlevelstart = 99


vim.g.vim_json_syntax_conceal = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browsex_viewer = "xdg-open"
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.c_comment_strings = 1 --can be any value
set.pumheight = 25
set.inccommand = 'split'
set.shada = "'1000,%"

-- see yanky config for clipboard settingss



--setting clipboard settings
if os.getenv("DISPLAY") then
  --if not os.getenv("SSH_CONNECTION") and not os.getenv("CHROME_REMOTE_DESKTOP_SESSION") then
  vim.opt.clipboard = 'unnamedplus'
  --end
else
end

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

if vim.g.neovide then
  vim.o.guifont = "InputMono Nerd Font:h8"
  vim.g.neovide_position_animation_length = 0.0625
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_animation_length = 0
end
---- Call the function to set up the clipboard
--setup_tmux_clipboard()
