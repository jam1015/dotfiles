-------- setting up mapping scheme
local opts = { remap = false, silent = true }
local keymap = vim.keymap.set

-------- setting leader
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.mapllocaleader = "\\"





--------------------------------------------- commands to be moved to terminal/navigation plugin

keymap("t", "<C-;>", "<C-\\><C-n>", opts)
keymap("t", "<localleader><Esc>", "<C-\\><C-N>", opts)

if os.getenv("TMUX") then
	keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { remap = true, silent = true })
else
	--using my favored tmux prefix
	keymap("n", "<C-a>", "<C-w>", { remap = true, silent = true })
	keymap("t", "<C-a>", "<C-\\><C-n><C-a>", { remap = true, silent = true })
	keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { remap = true, silent = true })
end




local function terminal_close_autocmd()
	local current_buf = vim.api.nvim_get_current_buf()
	local augroup_name = tostring(current_buf) ..
		"_" .. vim.fn.jobpid(vim.b.terminal_job_id) .. "_" .. string.format('%x', os.time() + math.random(1000))

	local function delete_term_buf_autocmd(ev_outer)
		local function close_term_buffer(ev_inner)
			local buf = ev_inner.buf
			vim.cmd([[bdelete ]] .. buf)

			return true
		end
		vim.api.nvim_create_autocmd("TermClose",
			{
				group = augroup_name,
				buffer = ev_outer.buf,
				callback = close_term_buffer,
				once = true
			})
		return true
	end

	vim.api.nvim_create_augroup(augroup_name, { clear = false })

	vim.api.nvim_create_autocmd("TermOpen",
		{
			group = augroup_name,
			callback = delete_term_buf_autocmd,
			once = true,
		})
end

local function term_vsplit()
	if vim.bo.buftype == 'terminal' then
		local pid = vim.fn.jobpid(vim.b.terminal_job_id)
		local pwd
		if vim.fn.has('win32') == 1 then -- For Windows
			vim.cmd('vsplit | term')
		elseif vim.fn.has('unix') == 1 then -- For Unix/Linux
			pwd = vim.fn.systemlist('readlink /proc/' .. pid .. '/cwd')[1]
			if pwd == "" or pwd == nil then
				pwd = vim.fn.systemlist('lsof -p ' .. pid .. ' | grep cwd | awk \'{print $NF}\'')[1]
			end
			vim.cmd('vsplit')
			terminal_close_autocmd()
			vim.cmd('term sh -c \'cd "' .. pwd .. '" && exec $SHELL\'')
		end
	else
		vim.cmd('vsplit')
	end
end

local function term_hsplit()
	if vim.bo.buftype == 'terminal' then
		local pid = vim.fn.jobpid(vim.b.terminal_job_id)
		local pwd
		if vim.fn.has('win32') == 1 then -- For Windows
			vim.cmd('split | term')
		elseif vim.fn.has('unix') == 1 then -- For Unix/Linux
			pwd = vim.fn.systemlist('readlink /proc/' .. pid .. '/cwd')[1]
			if pwd == "" or pwd == nil then
				pwd = vim.fn.systemlist('lsof -p ' .. pid .. ' | grep cwd | awk \'{print $NF}\'')[1]
			end
			vim.cmd('split')
			terminal_close_autocmd()
			vim.cmd('term sh -c \'cd "' .. pwd .. '" && exec $SHELL\'')
		end
	else
		vim.cmd('split')
	end
end


vim.api.nvim_create_user_command('Tsplit', term_hsplit, { bar = true })
vim.api.nvim_create_user_command('Tvsplit', term_vsplit, { bar = true })

keymap("n", "<C-a>s", term_hsplit, opts)
keymap("t", "<C-a>s", term_hsplit, opts)
keymap("n", "<C-a>v", term_vsplit, opts)
keymap("t", "<C-a>v", term_vsplit, opts)



keymap("t", "<C-o>", "<C-\\><C-o>", { remap = false, silent = true }) --issue single terminal command



keymap("i", "<C-r>", "<C-r><C-p>", opts) --helpw sith pasting from insert moce
keymap("c", "%%", "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { expr = true, remap = false })

keymap("n", "<leader>gt", "<cmd>tabprev<cr>", { remap = true, silent = true, expr = true })




------------------------------ directional help should be moved to plugin
require("keymaps.directional_help")


------------------------------- general keymaps that can stay
vim.cmd([[

" changing size
if bufwinnr(1)
	map + <C-W>+
	map - <C-W>-
	map <leader>. <C-W><
	map <leader>, <C-W>>
	endif



	" get current file
	cnoreabbr <expr> %% fnameescape(expand('%:p'))
	" new windows

	" in insert mode control u deletes to beginning of line, this makes it part of a new change
	inoremap <C-U> <C-G>u<C-U>


	" motion based on visual lines
	let g:toggle_mappings = 1

	function! ToggleMappings()
	let g:toggle_mappings = !g:toggle_mappings
	endfunction

	nnoremap <silent> <expr> $ g:toggle_mappings ? 'g$' : '$'
	nnoremap <silent> <expr> 0 g:toggle_mappings ? 'g0' : '0'
	nnoremap <silent> <expr> ^ g:toggle_mappings ? 'g^' : '^'
	nnoremap <silent> <expr> j g:toggle_mappings ? 'gj' : 'j'
	nnoremap <silent> <expr> k g:toggle_mappings ? 'gk' : 'k'
	command! ToggleMyMappings call ToggleMappings()
	]])



---------    setting C-; as escape like in terminal, can remove if I find a better use
keymap("i", "<C-;>", "<C-[>", opts)
keymap("x", "<C-;>", "<C-[>", opts)
keymap("v", "<C-;>", "<C-[>", opts)
keymap("o", "<C-;>", "<C-[>", opts)
keymap("n", "<C-;>", "<C-[>", opts)


keymap("i", "<C-j>", "<C-x><C-o>", { remap = false, silent = true }) -- activate omni completeion
--keymap("n", "<C-w>s", "<cmd>colorscheme blue<cr>", opts)

keymap("n", "<leader>km",
	":redir! > nvim_keys.txt<CR>:silent map<CR>:redir END<CR>:edit nvim_keys.txt<CR>:g/^<Plug>\\|^<SNR>/d<CR>"
	, opts) --output keymap
