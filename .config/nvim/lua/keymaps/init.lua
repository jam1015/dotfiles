local wk = require("which-key")
local opts = { remap = false, silent = true }
local keymap = vim.keymap.set

keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.mapllocaleader = "\\"

-- defining functions that can be used to make command line abbreviations elsewhere
wk.register({ ["<leader>ll"] = { "<cmd>nohlsearch<CR>", "nohighlight" } ,["<leader>l"] = { name = "aesthetics"}})


keymap("i", "<C-;>", "<C-[>", opts)
keymap("x", "<C-;>", "<C-[>", opts)
keymap("v", "<C-;>", "<C-[>", opts)
keymap("o", "<C-;>", "<C-[>", opts)
keymap("n", "<C-;>", "<C-[>", opts)

if os.getenv("TMUX") then
	keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { remap = true, silent = true })
else
	--using my favored tmux prefix
	keymap("n", "<C-a>", "<C-w>", { remap = true, silent = true })
	keymap("t", "<C-a>", "<C-w>", { remap = true, silent = true })
	keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { remap = true, silent = true })
end

keymap("t", "<C-;>", "<C-\\><C-n>", opts)
keymap("i", "<C-j>", "<C-x><C-o>", { remap = false, silent = true }) -- activate omni completeion
--keymap("n", "<C-w>s", "<cmd>colorscheme blue<cr>", opts)

keymap("n", "<leader>km",
	":redir! > nvim_keys.txt<CR>:silent map<CR>:redir END<CR>:edit nvim_keys.txt<CR>:g/^<Plug>\\|^<SNR>/d<CR>"
	, opts) --output keymap

--https://neovim.io/doc/user/map.html#user-commands
--https://neovim.io/doc/user/api.html and search nvim_create_user_command
-- and section 40 of the manual


local function term_vsplit()
	if vim.bo.buftype == 'terminal' then
		local pid = vim.fn.jobpid(vim.b.terminal_job_id)
		local pwd
		if vim.fn.has('win32') == 1 then -- For Windows
			vim.cmd('vsplit | term')
		elseif vim.fn.has('unix') == 1 then -- For Unix/Linux
			pwd = vim.fn.systemlist('readlink /proc/' .. pid .. '/cwd')[1]
			vim.cmd('vsplit | term sh -c \'cd "' .. pwd .. '" && exec $SHELL\'')
		else -- For MacOS
			pwd = vim.fn.systemlist('lsof -p ' .. pid .. ' | grep cwd | awk \'{print $NF}\'')[1]
			vim.cmd('vsplit | term sh -c \'cd "' .. pwd .. '" && exec $SHELL\'')
		end
	else
		vim.cmd('vsplit')
	end
end
--
local function term_hsplit()
	if vim.bo.buftype == 'terminal' then
		local pid = vim.fn.jobpid(vim.b.terminal_job_id)
		local pwd
		if vim.fn.has('win32') == 1 then -- For Windows
			vim.cmd('split | term')
		elseif vim.fn.has('unix') == 1 then -- For Unix/Linux
			pwd = vim.fn.systemlist('readlink /proc/' .. pid .. '/cwd')[1]
			vim.cmd('split | term sh -c \'cd "' .. pwd .. '" && exec $SHELL\'')
		else -- For MacOS
			pwd = vim.fn.systemlist('lsof -p ' .. pid .. ' | grep cwd | awk \'{print $NF}\'')[1]
			vim.cmd('split | term sh -c \'cd "' .. pwd .. '" && exec $SHELL\'')
		end
	else
		vim.cmd('split')
	end
end

vim.api.nvim_create_user_command('Tsplit', term_hsplit, { bar = true })
vim.api.nvim_create_user_command('Tvsplit', term_vsplit, { bar = true })

keymap("n", "<C-w>s", term_hsplit, opts)
keymap("t", "<C-w>s", term_hsplit, opts)
keymap("n", "<C-w>v", term_vsplit, opts)
keymap("t", "<C-w>v", term_vsplit, opts)


keymap("t", "<C-o>", "<C-\\><C-o>", { remap = false, silent = true }) --issue single terminal command
keymap("t", "<localleader><Esc>", "<C-\\><C-N>", opts)
keymap("n", "<leader>tt", "<cmd>terminal<cr>i", opts)
keymap("n", "<leader>tv", "<C-w>v<cmd>terminal<cr>i", opts)
keymap("n", "<leader>ts", "<C-w>s<cmd>terminal<cr>i", opts)


keymap("i", "<C-r>", "<C-r><C-p>", opts) --helpw sith pasting from insert moce
keymap("c", "%%", "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { expr = true, remap = false })

keymap("n", "<leader>gt", "<cmd>tabprev<cr>", { remap = true, silent = true, expr = true })

require("keymaps.directional_help")


vim.cmd([[




" changing size
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
  map <leader>. <C-W><
  map <leader>, <C-W>>
endif

noremap <leader>cf :call CreateFile(expand("<cfile>"))<CR>

map Q gq
" get current file
cnoreabbr <expr> %% fnameescape(expand('%:p'))
" new windows

" in insert mode control u deletes to beginning of line, this makes it part of a new change
inoremap <C-U> <C-G>u<C-U>


""add type these after a search to instantly move text
""move to text
"cnoremap $t <CR>:t''<CR>
""move text to
"cnoremap $m <CR>:m''<CR>
""delete
"cnoremap $d <CR>:d<CR>``
"
"" makes count up and down motions actual lines if a number is given
"nnoremap <expr> k (v:count == -1 ? 'gk' : 'k')
"nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
"
""force visual motion
"nnoremap dj dvj
"nnoremap dk dvk
"nnoremap 0 ^
"nnoremap ^ 0
""nnoremap $ g$
""nnoremap g$ $
""nnoremap 0 g0
""nnoremap g0 0
""nnoremap ^ g^
""nnoremap g^ ^
]])
