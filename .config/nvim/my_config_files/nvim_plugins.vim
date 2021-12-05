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
			nnoremap  <leader>w :HopWord<CR>
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
			

lua <<EOF
 require'lightspeed'.setup{
limit_ft_matches = 1000,
exit_after_idle_msecs = {
	labeled = 1500, unlabeled = 2000,
	},
}

EOF

"omap ; <Plug>Lightspeed_;_ft
"nmap ; <Plug>Lightspeed_;_ft
"omap , <Plug>Lightspeed_,_ft
"nmap , <Plug>Lightspeed_,_ft

			"trouble.nvim
			call minpac#add("folke/trouble.nvim")
			call minpac#add("kyazdani42/nvim-web-devicons")
			lua << EOF
  require("trouble").setup {
	  height = 10, -- height of the trouble list
    icons = true, -- use devicons for filenames
    mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    action_keys = { -- key mappings for actions in the trouble list
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small poup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_lsp_diagnostic_signs = true
  }
EOF


			call minpac#add("nvim-treesitter/nvim-treesitter", {'do': ':TSUpdate'})
			source ~/.config/nvim/my_config_files/treesitterconfig.vim

		call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
			"call minpac#add("neovim/nvim-lspconfig")
			"source ~/.config/nvim/my_config_files/lspconfig.vim
