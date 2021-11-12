"----- firenvim config
		call minpac#add('glacambre/firenvim', { 'type': 'opt', 'do': 'packadd firenvim | call firenvim#install(0)'})
			let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 1,
            \ 'takeover': 'never',
        \ },
    \ }
\ }


		if exists('g:started_by_firenvim')
			packadd firenvim
			set guifont=Consolas:h18
		endif

" moving on -------------------
		call minpac#add('BurntSushi/ripgrep')
		call minpac#add('nvim-telescope/telescope-fzf-native.nvim')
		call minpac#add('nvim-lua/plenary.nvim')
		call minpac#add('nvim-telescope/telescope.nvim')
		call minpac#add('sharkdp/fd')


		
			call minpac#add("phaazon/hop.nvim") "see whether I can overwrite the s from lightspeed, keeping the f/t
			lua require'hop'.setup()
			nnoremap  <leader>w :HopWordAC<CR>
			nnoremap  <leader>W :HopWordBC<CR>
			"nnoremap  <leader><leader>w :HopWord<CR>
			nnoremap  <leader>/ :HopPatternAC<CR>
			nnoremap  <leader>? :HopPatternBC<CR>
			"nnoremap  <leader>s :HopChar2<CR>
			"nnoremap  S :HopChar2BC<CR>
			"nnoremap  <leader><leader>f :HopChar1<CR>
			"nnoremap  F :HopChar1BC<CR>
			"lua vim.api.nvim_set_keymap('n', '<leader>f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
			"lua vim.api.nvim_set_keymap('n', '<leader>F', "<cmd>lua require'hop'.hinhar1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})
			"lua vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
			"lua vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})
			"lightspeed
			call minpac#add("ggandor/lightspeed.nvim")
lua require'lightspeed'.opts['limit_ft_matches'] = 1000
omap ; <Plug>Lightspeed_;_ft
nmap ; <Plug>Lightspeed_;_ft
omap , <Plug>Lightspeed_,_ft
nmap , <Plug>Lightspeed_,_ft
			"trouble.nvim
			call minpac#add("folke/trouble.nvim")
			call minpac#add("nvim-treesitter/nvim-treesitter", {'do': ':TSUpdate'})
			source ~/.config/nvim/my_config_files/treesitterconfig.vim
			call minpac#add("neovim/nvim-lspconfig")
			source ~/.config/nvim/my_config_files/lspconfig.vim
