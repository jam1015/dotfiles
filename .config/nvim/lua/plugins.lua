-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- recompile on changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  -- Packer can manage itself
   use 'wbthomason/packer.nvim'
  --

use {'folke/tokyonight.nvim', branc = 'main', config = function()
	vim.g.tokyonight_style = "night"
end}
-- 
use {"ellisonleao/gruvbox.nvim", config = function()
vim.o.background = "dark"
 end}

-- plugins
use 'tpope/vim-unimpaired'
 use {'lervag/vimtex',
 
 config = function()
  	vim.cmd([[
  
 let g:vimtex_view_method = 'zathura'
 let g:vimtex_view_general_viewer = 'zathura'
 let g:vimtex_view_enabled=1
 
 function! Synctex()
     let vimura_param = " --synctex-forward " . line('.') . ":" . col('.') . ":" . expand('%:p') . " " . substitute(expand('%:p'),"tex$","pdf", "")
     if has('nvim')
         call jobstart("vimura neovim" . vimura_param)
     else
         exe "silent !vimura vim" . vimura_param . "&"
     endif
     redraw!
 endfunction
 
 map <localleader>st :call Synctex()<cr>
 map <localleader>lv :VimtexView<cr>
  	]])
  end
 
 }
use 'inkarkat/vim-visualrepeat'
use 'kana/vim-textobj-user'
use 'kana/vim-textobj-entire'
use 'fladson/vim-kitty'
use 'ap/vim-you-keep-using-that-word'
use 'tpope/vim-surround'
use 'bronson/vim-visual-star-search'
use 'tpope/vim-repeat'
use 'qpkorr/vim-bufkill'
use 'kevinoid/vim-jsonc'
use {'jpalardy/vim-slime', config = function() vim.g.slime_target = "tmux" end}
use 'mattn/emmet-vim'

use { -- run 'call firenvim#install(0)' to perhaps fix issues when it is not running in browser
    'glacambre/firenvim', 
    run = function() vim.fn['firenvim#install'](0) end, 
	config = function()
	vim.cmd([[
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
		set guifont=Consolas:h11
	endif
	]])
end
}

use {'jalvesaq/Nvim-R', branch = 'stable'}

use {
'nvim-telescope/telescope.nvim',
requires = { {'nvim-lua/plenary.nvim'} ,{'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }


}
}
-- 
use {"phaazon/hop.nvim", 
config = function()
 	vim.cmd([[
 lua require'hop'.setup()
 nnoremap  <leader>ww :HopWord<CR>
 "nnoremap  <leader><leader>w :HopWord<CR>
 nnoremap  <leader>// :HopPatternAC<CR>
 nnoremap  <leader>?? :HopPatternBC<CR>
 "nnoremap  <leader>s :HopChar2<CR>
 "nnoremap  S :HopChar2BC<CR>
 "nnoremap  <leader><leader>f :HopChar1<CR>
 "nnoremap  F :HopChar1BC<CR>
 "lua vim.api.nvim_set_keymap('n', '<leader>f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
 "lua vim.api.nvim_set_keymap('n', '<leader>F', "<cmd>lua require'hop'.hinhar1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})
 "lua vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
 "lua vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})
 
 	]])
 end
 }

use {"ggandor/lightspeed.nvim", config = function()
vim.cmd([[
nmap s <Plug>Lightspeed_omni_s
"omap ; <Plug>Lightspeed_;_ft
"nmap ; <Plug>Lightspeed_;_ft
"omap , <Plug>Lightspeed_,_ft
"nmap , <Plug>Lightspeed_,_ft
]])
require'lightspeed'.setup({
ignore_case = true,
limit_ft_matches = 1000,
exit_after_idle_msecs = {
	labeled = 3000, unlabeled = 2000,
	},
})
end}
 
use {'nvim-treesitter/nvim-treesitter',
run = 'TSUpdate',
config = function()
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>is",
      node_incremental = "<leader>ni",
      scope_incremental = "<leader>si",
      node_decremental = "<leader>nd",
    },
  },
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",
  ignore_install = {"phpdoc", "tree-sitter-phpdoc", },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
     disable = { "latex", "help", "markdown"},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
end
}

use {"folke/trouble.nvim", requires = {"kyazdani42/nvim-web-devicons"}, config = function()

require("trouble").setup ({
	height = 10, -- height of the trouble list
	icons = true, -- use devicons for filenames
	mode = "workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
	fold_open = "v", -- icon used for open folds
	fold_closed = ">", -- icon used for closed folds
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
indent_lines = false, -- add an indent guide below the fold icons
auto_open = false, -- automatically open the list when you have diagnostics
auto_close = false, -- automatically close the list when you have no diagnostics
auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
auto_fold = false, -- automatically fold a file trouble list at creation
signs = {
	-- icons / text used for a diagnostic
	error = "ERROR",
	warning = "WARNING",
	hint = "HINT",
	information = "INFO",
 	other = "other"
	},
use_diagnostic_signs = true
})
end

}

-- use {"neovim/nvim-lspconfig",
-- after = 'coc.nvim',
-- config = function()
-- local nvim_lsp = require('lspconfig')
-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
-- 
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
-- 
--   -- Mappings.
--   local opts = { noremap=true, silent=true }
-- 
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts) -- Changed from <Space>D
--   buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   -- shows the error
--   buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
--   buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
--   buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--   buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
--   buf_set_keymap("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
-- 
-- end
-- -- Use a loop to conveniently call 'setup' on multiple servers and
-- -- map buffer local keybindings when the language server attaches
-- require'lspconfig'.sqlls.setup{cmd = {"sql-language-server","up","--method","stdio"}}
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- require'lspconfig'.html.setup {
-- 	  capabilities = capabilities,
-- 	  }
-- -- lua
-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
-- 
-- -- require'lspconfig'.sumneko_lua.setup {
-- --   settings = {
-- --     Lua = {
-- --       runtime = {
-- --         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
-- --         version = 'LuaJIT',
-- --         -- Setup your lua path
-- --         path = runtime_path,
-- --       },
-- --       diagnostics = {
-- --         -- Get the language server to recognize the `vim` global
-- --         globals = {'vim'},
-- --       },
-- --       workspace = {
-- --         -- Make the server aware of Neovim runtime files
-- --         library = vim.api.nvim_get_runtime_file("", true),
-- --       },
-- --       -- Do not send telemetry data containing a randomized but unique identifier
-- --       telemetry = {
-- --         enable = false,
-- --       },
-- --     },
-- -- },
-- -- }
-- 
-- -- other servers
-- --  clangd pyright texlab
-- local servers = {"clangd","r_language_server","texlab", "pyright","jsonls","cssls","eslint"}
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
-- 	on_attach = on_attach,
-- 	flags = {
-- 	  debounce_text_changes = 150,
-- 	}
--   }
-- 
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
-- 	vim.lsp.diagnostic.on_publish_diagnostics, {
-- 		virtual_text = {spacing = 0,}
-- 	}
-- )
-- end
-- 
-- end}

use {'neoclide/coc.nvim', branch = 'release',
config = function()
	vim.cmd(
	[[

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

xmap <leader>aa  <Plug>(coc-codeaction-selected)
nmap <leader>aa  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>ca  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)
" formatting
nmap <leader>ff <plug>(coc-format)

let g:coc_start_at_startup = 1
inoremap <silent><expr> <c-space> coc#refresh()
"enable or disable coc
cnoreabbrev <expr> dd  getcmdtype() == ":" && getcmdline() == "dd" ? "CocDisable" : "dd"
cnoreabbrev <expr> de  getcmdtype() == ":" && getcmdline() == "de" ? "CocEnable" : "de"

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

inoremap <silent><expr> <Tab>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
	]]
	)

end}



end)


