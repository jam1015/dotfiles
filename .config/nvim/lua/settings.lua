vim.g.loaded_gtags_cscope = 1
local set = vim.opt
vim.cmd([[ highlight Comment cterm=italic gui=italic]])
--vim.g.debug = false

set.bg = "dark"

-- Get the current hour (0-23)
local current_hour = tonumber(os.date("%H"))

-- Debug output (optional)

--Define your condition: day (6 AM to 5:59 PM) vs. night
local colorscheme = ""
if current_hour >= 6 and current_hour < 18 then
  -- daytime colorscheme
  colorscheme = "bluloco"
else
  colorscheme = "bluloco"
end

if os.getenv("DISPLAY") then
  local status_ok, out = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not status_ok then
    vim.cmd([[colorscheme elflord]])
  end
else
  vim.cmd([[colorscheme elflord]]) end

-- add complete/completeopt
set.modeline = false
set.timeoutlen = 50
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
set.scrolloff = 5   -- show a few lines around cursor
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
set.exrc = true
set.number = true
set.relativenumber = true
set.equalalways = false
set.spelllang = "en-custom"
if os.getenv("DISPLAY") then
  set.termguicolors = true
else
end
--vim.api.nvim_create_autocmd("BufReadPost", {
--  pattern = "*",
--  callback = function()
--    -- start with manual (instant open)
--    vim.wo.foldmethod = "manual"
--
--    vim.defer_fn(function()
--      -- only set if the buffer is still current and window valid
--      if vim.api.nvim_buf_is_valid(vim.api.nvim_get_current_buf()) then
--        vim.wo.foldmethod = "expr"
--        vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
--      end
--    end, 5000) -- delay in ms
--  end,
--})
--set.foldlevelstart = 99

vim.g.vim_json_syntax_conceal = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browsex_viewer = "xdg-open"
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.c_comment_strings = 1 --can be any value
set.pumheight = 25
set.inccommand = 'split'
set.shada = "'1000"

-- see yanky config for clipboard settingss

--setting clipboard settings
if os.getenv("DISPLAY") then
  --if not os.getenv("SSH_CONNECTION") and not os.getenv("CHROME_REMOTE_DESKTOP_SESSION") then
  vim.opt.clipboard = 'unnamedplus'
  --end
else
end

local function setup_clipboard()
  if os.getenv("TMUX") then
    vim.g.clipboard = {
      name = 'tmux-clipboard',
      copy = {
        ['+'] = { 'tmux', 'load-buffer', '-w', '-' },
        ['*'] = { 'tmux', 'load-buffer', '-w', '-' },
      },
      paste = {
        ['+'] = { 'tmux', 'save-buffer', '-' },
        ['*'] = { 'tmux', 'save-buffer', '-' },
      },
      cache_enabled = false,
    }
  elseif os.getenv("WAYLAND_DISPLAY") then
    vim.g.clipboard = {
      name = 'wl-clipboard',
      copy = {
        ['+'] = { 'wl-copy', '--type', 'text/plain' },
        ['*'] = { 'wl-copy', '--primary', '--type', 'text/plain' },
      },
      paste = {
        ['+'] = { 'wl-paste', '--no-newline' },
        ['*'] = { 'wl-paste', '--no-newline', '--primary' },
      },
      cache_enabled = false,
    }
  end
end

if vim.g.neovide then
  vim.o.guifont = "InputMono Nerd Font:h8"
  vim.g.neovide_position_animation_length = 0.0625
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_hack = true
  vim.g.neovide_cursor_smooth_blink = true
end
-- Call the function to set up the clipboard
setup_clipboard()
