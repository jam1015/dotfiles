-------- setting up mapping scheme
local opts = { remap = false, silent = true }
local keymap = vim.keymap.set

-------- setting leader
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.mapllocaleader = "\\"


--------------------------------------------- commands to be moved to terminal/navigation plugin


if os.getenv("TMUX") then
	keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { remap = true, silent = true })
else
	--using my favored tmux prefix
	keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { remap = true, silent = true })
end




keymap("t", "<C-o>", "<C-\\><C-o>", { remap = false, silent = true }) --issue single terminal command



--keymap("i", "<C-r>", "<C-r><C-p>", opts) --helpw sith pasting from insert moode but messes with flit
keymap("c", "<C-d>", "getcmdtype() == ':' ? expand('%:p:h').'/' : ''", { expr = true, remap = false })


vim.cmd([[
command! -range=% Yp <line1>,<line2>yank | put
cnoreabbrev <expr> yp getcmdtype() == ":" && getcmdline() == "yp" ? "Yp" : "yp"
]])



------------------------------- general keymaps that can stay
vim.cmd([[

" changing size
if bufwinnr(1)
	map + <C-W>+
	map - <C-W>-
	map <leader>. <C-W><
	map <leader>, <C-W>>
endif
	" in insert mode control u deletes to beginning of line, this makes it part of a new change
	inoremap <C-U> <C-G>u<C-U>


	" motion based on visual lines
	let g:toggle_mappings = 0

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









keymap("i", "<C-i>", "<C-x><C-o>", { remap = false, silent = true }) -- activate omni completeion
--keymap("n", "<C-w>s", "<cmd>colorscheme blue<cr>", opts)

keymap("n", "<leader>km",
	":redir! > nvim_keys.txt<CR>:silent map<CR>:redir END<CR>:edit nvim_keys.txt<CR>:g/^<Plug>\\|^<SNR>/d<CR>"
	, opts) --output keymap
