-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/jordan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/jordan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/jordan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/jordan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/jordan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Nvim-R"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/Nvim-R",
    url = "https://github.com/jalvesaq/Nvim-R"
  },
  ["coc.nvim"] = {
    config = { "\27LJ\2\nØ\f\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0è\f\nnmap <silent> [g <Plug>(coc-diagnostic-prev)\nnmap <silent> ]g <Plug>(coc-diagnostic-next)\n\" GoTo code navigation.\nnmap <silent> gd <Plug>(coc-definition)\nnmap <silent> gy <Plug>(coc-type-definition)\nnmap <silent> <leader>gi <Plug>(coc-implementation)\nnmap <silent> gr <Plug>(coc-references)\n\nxmap <leader>aa  <Plug>(coc-codeaction-selected)\nnmap <leader>aa  <Plug>(coc-codeaction-selected)\n\" Remap keys for applying codeAction to the current buffer.\nnmap <leader>ac  <Plug>(coc-codeaction)\n\" Apply AutoFix to problem on the current line.\nnmap <leader>ca  <Plug>(coc-fix-current)\n\n\" Run the Code Lens action on the current line.\nnmap <leader>cl  <Plug>(coc-codelens-action)\n\" formatting\nnmap <leader>ff <plug>(coc-format)\n\nlet g:coc_start_at_startup = 1\ninoremap <silent><expr> <c-space> coc#refresh()\n\"enable or disable coc\ncnoreabbrev <expr> dd  getcmdtype() == \":\" && getcmdline() == \"dd\" ? \"CocDisable\" : \"dd\"\ncnoreabbrev <expr> de  getcmdtype() == \":\" && getcmdline() == \"de\" ? \"CocEnable\" : \"de\"\n\n\" use <tab> for trigger completion and navigate to the next complete item\nfunction! s:check_back_space() abort\n\tlet col = col('.') - 1\n\treturn !col || getline('.')[col - 1]  =~ '\\s'\nendfunction\n\ninoremap <expr> <Tab> pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"\ninoremap <expr> <S-Tab> pumvisible() ? \"\\<C-p>\" : \"\\<S-Tab>\"\n\n\" Use K to show documentation in preview window.\nnnoremap <silent> K :call <SID>show_documentation()<CR>\n\ninoremap <silent><expr> <Tab>\n\t\t\t\\ pumvisible() ? \"\\<C-n>\" :\n\t\t\t\\ <SID>check_back_space() ? \"\\<Tab>\" :\n\t\t\t\\ coc#refresh()\n\t\bcmd\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  firenvim = {
    config = { "\27LJ\2\në\3\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0Ò\2\tlet g:firenvim_config = {\n\t\t\t\t\\ 'globalSettings': {\n\t\t\t\t\t\\ 'alt': 'all',\n\t\t\t\t\t\\  },\n\t\t\t\t\t\\ 'localSettings': {\n\t\t\t\t\t\t\\ '.*': {\n\t\t\t\t\t\t\t\\ 'cmdline': 'neovim',\n\t\t\t\t\t\t\t\\ 'content': 'text',\n\t\t\t\t\t\t\t\\ 'priority': 1,\n\t\t\t\t\t\t\t\\ 'takeover': 'never',\n\t\t\t\t\t\t\t\\ },\n\t\t\t\t\t\t\t\\ }\n\t\t\t\t\t\t\t\\ }\n\n\tif exists('g:started_by_firenvim')\n\t\tpackadd firenvim\n\t\tset guifont=Consolas:h11\n\tendif\n\t\bcmd\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["gruvbox.nvim"] = {
    config = { "\27LJ\2\n1\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\tdark\15background\6o\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/gruvbox.nvim",
    url = "https://github.com/ellisonleao/gruvbox.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\n∞\b\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ê\b lua require'hop'.setup()\n nnoremap  <leader>ww :HopWord<CR>\n \"nnoremap  <leader><leader>w :HopWord<CR>\n nnoremap  <leader>// :HopPatternAC<CR>\n nnoremap  <leader>?? :HopPatternBC<CR>\n \"nnoremap  <leader>s :HopChar2<CR>\n \"nnoremap  S :HopChar2BC<CR>\n \"nnoremap  <leader><leader>f :HopChar1<CR>\n \"nnoremap  F :HopChar1BC<CR>\n \"lua vim.api.nvim_set_keymap('n', '<leader>f', \"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>\", {})\n \"lua vim.api.nvim_set_keymap('n', '<leader>F', \"<cmd>lua require'hop'.hinhar1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>\", {})\n \"lua vim.api.nvim_set_keymap('n', 's', \"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>\", {})\n \"lua vim.api.nvim_set_keymap('n', 'S', \"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>\", {})\n \n \t\bcmd\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["lightspeed.nvim"] = {
    config = { "\27LJ\2\n \2\0\0\4\0\t\0\r6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0005\3\a\0=\3\b\2B\0\2\1K\0\1\0\26exit_after_idle_msecs\1\0\2\14unlabeled\3–\15\flabeled\3∏\23\1\0\2\16ignore_case\2\21limit_ft_matches\3Ë\a\nsetup\15lightspeed\frequireú\1nmap s <Plug>Lightspeed_omni_s\n\"omap ; <Plug>Lightspeed_;_ft\n\"nmap ; <Plug>Lightspeed_;_ft\n\"omap , <Plug>Lightspeed_,_ft\n\"nmap , <Plug>Lightspeed_,_ft\n\bcmd\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n∑\3\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0025\3\b\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\14highlight\fdisable\1\4\0\0\nlatex\thelp\rmarkdown\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\1\3\0\0\vphpdoc\23tree-sitter-phpdoc\26incremental_selection\1\0\2\21ensure_installed\ball\17sync_install\1\fkeymaps\1\0\4\19init_selection\15<leader>is\22scope_incremental\15<leader>si\21node_incremental\15<leader>ni\21node_decremental\15<leader>nd\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\n8\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\nnight\21tokyonight_style\6g\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n∞\4\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\nsigns\1\0\5\16information\tINFO\nerror\nERROR\thint\tHINT\fwarning\fWARNING\nother\nother\16action_keys\16toggle_fold\1\3\0\0\azA\aza\15open_folds\1\3\0\0\azR\azr\16close_folds\1\3\0\0\azM\azm\15jump_close\1\2\0\0\6o\tjump\1\3\0\0\t<cr>\n<tab>\1\0\t\frefresh\6r\vcancel\n<esc>\tnext\6j\fpreview\6p\nhover\6K\19toggle_preview\6P\rprevious\6k\16toggle_mode\6m\nclose\6q\1\0\v\14fold_open\6v\15auto_close\1\17auto_preview\2\14auto_fold\1\16fold_closed\6>\14auto_open\1\17indent_lines\1\nicons\2\vheight\3\n\tmode\26workspace_diagnostics\25use_diagnostic_signs\2\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-bufkill"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-bufkill",
    url = "https://github.com/qpkorr/vim-bufkill"
  },
  ["vim-jsonc"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-jsonc",
    url = "https://github.com/kevinoid/vim-jsonc"
  },
  ["vim-kitty"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-kitty",
    url = "https://github.com/fladson/vim-kitty"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-slime"] = {
    config = { "\27LJ\2\n3\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\ttmux\17slime_target\6g\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-slime",
    url = "https://github.com/jpalardy/vim-slime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-textobj-entire",
    url = "https://github.com/kana/vim-textobj-entire"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-visual-star-search"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-visual-star-search",
    url = "https://github.com/bronson/vim-visual-star-search"
  },
  ["vim-visualrepeat"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-visualrepeat",
    url = "https://github.com/inkarkat/vim-visualrepeat"
  },
  ["vim-you-keep-using-that-word"] = {
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vim-you-keep-using-that-word",
    url = "https://github.com/ap/vim-you-keep-using-that-word"
  },
  vimtex = {
    config = { "\27LJ\2\n»\4\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0®\4  \n let g:vimtex_view_method = 'zathura'\n let g:vimtex_view_general_viewer = 'zathura'\n let g:vimtex_view_enabled=1\n \n function! Synctex()\n     let vimura_param = \" --synctex-forward \" . line('.') . \":\" . col('.') . \":\" . expand('%:p') . \" \" . substitute(expand('%:p'),\"tex$\",\"pdf\", \"\")\n     if has('nvim')\n         call jobstart(\"vimura neovim\" . vimura_param)\n     else\n         exe \"silent !vimura vim\" . vimura_param . \"&\"\n     endif\n     redraw!\n endfunction\n \n map <localleader>st :call Synctex()<cr>\n map <localleader>lv :VimtexView<cr>\n  \t\bcmd\bvim\0" },
    loaded = true,
    path = "/home/jordan/.local/share/nvim/site/pack/packer/start/vimtex",
    url = "https://github.com/lervag/vimtex"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: vimtex
time([[Config for vimtex]], true)
try_loadstring("\27LJ\2\n»\4\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0®\4  \n let g:vimtex_view_method = 'zathura'\n let g:vimtex_view_general_viewer = 'zathura'\n let g:vimtex_view_enabled=1\n \n function! Synctex()\n     let vimura_param = \" --synctex-forward \" . line('.') . \":\" . col('.') . \":\" . expand('%:p') . \" \" . substitute(expand('%:p'),\"tex$\",\"pdf\", \"\")\n     if has('nvim')\n         call jobstart(\"vimura neovim\" . vimura_param)\n     else\n         exe \"silent !vimura vim\" . vimura_param . \"&\"\n     endif\n     redraw!\n endfunction\n \n map <localleader>st :call Synctex()<cr>\n map <localleader>lv :VimtexView<cr>\n  \t\bcmd\bvim\0", "config", "vimtex")
time([[Config for vimtex]], false)
-- Config for: firenvim
time([[Config for firenvim]], true)
try_loadstring("\27LJ\2\në\3\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0Ò\2\tlet g:firenvim_config = {\n\t\t\t\t\\ 'globalSettings': {\n\t\t\t\t\t\\ 'alt': 'all',\n\t\t\t\t\t\\  },\n\t\t\t\t\t\\ 'localSettings': {\n\t\t\t\t\t\t\\ '.*': {\n\t\t\t\t\t\t\t\\ 'cmdline': 'neovim',\n\t\t\t\t\t\t\t\\ 'content': 'text',\n\t\t\t\t\t\t\t\\ 'priority': 1,\n\t\t\t\t\t\t\t\\ 'takeover': 'never',\n\t\t\t\t\t\t\t\\ },\n\t\t\t\t\t\t\t\\ }\n\t\t\t\t\t\t\t\\ }\n\n\tif exists('g:started_by_firenvim')\n\t\tpackadd firenvim\n\t\tset guifont=Consolas:h11\n\tendif\n\t\bcmd\bvim\0", "config", "firenvim")
time([[Config for firenvim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\nnight\21tokyonight_style\6g\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: gruvbox.nvim
time([[Config for gruvbox.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\tdark\15background\6o\bvim\0", "config", "gruvbox.nvim")
time([[Config for gruvbox.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n∞\4\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\nsigns\1\0\5\16information\tINFO\nerror\nERROR\thint\tHINT\fwarning\fWARNING\nother\nother\16action_keys\16toggle_fold\1\3\0\0\azA\aza\15open_folds\1\3\0\0\azR\azr\16close_folds\1\3\0\0\azM\azm\15jump_close\1\2\0\0\6o\tjump\1\3\0\0\t<cr>\n<tab>\1\0\t\frefresh\6r\vcancel\n<esc>\tnext\6j\fpreview\6p\nhover\6K\19toggle_preview\6P\rprevious\6k\16toggle_mode\6m\nclose\6q\1\0\v\14fold_open\6v\15auto_close\1\17auto_preview\2\14auto_fold\1\16fold_closed\6>\14auto_open\1\17indent_lines\1\nicons\2\vheight\3\n\tmode\26workspace_diagnostics\25use_diagnostic_signs\2\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\n∞\b\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ê\b lua require'hop'.setup()\n nnoremap  <leader>ww :HopWord<CR>\n \"nnoremap  <leader><leader>w :HopWord<CR>\n nnoremap  <leader>// :HopPatternAC<CR>\n nnoremap  <leader>?? :HopPatternBC<CR>\n \"nnoremap  <leader>s :HopChar2<CR>\n \"nnoremap  S :HopChar2BC<CR>\n \"nnoremap  <leader><leader>f :HopChar1<CR>\n \"nnoremap  F :HopChar1BC<CR>\n \"lua vim.api.nvim_set_keymap('n', '<leader>f', \"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>\", {})\n \"lua vim.api.nvim_set_keymap('n', '<leader>F', \"<cmd>lua require'hop'.hinhar1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>\", {})\n \"lua vim.api.nvim_set_keymap('n', 's', \"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>\", {})\n \"lua vim.api.nvim_set_keymap('n', 'S', \"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>\", {})\n \n \t\bcmd\bvim\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Config for: coc.nvim
time([[Config for coc.nvim]], true)
try_loadstring("\27LJ\2\nØ\f\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0è\f\nnmap <silent> [g <Plug>(coc-diagnostic-prev)\nnmap <silent> ]g <Plug>(coc-diagnostic-next)\n\" GoTo code navigation.\nnmap <silent> gd <Plug>(coc-definition)\nnmap <silent> gy <Plug>(coc-type-definition)\nnmap <silent> <leader>gi <Plug>(coc-implementation)\nnmap <silent> gr <Plug>(coc-references)\n\nxmap <leader>aa  <Plug>(coc-codeaction-selected)\nnmap <leader>aa  <Plug>(coc-codeaction-selected)\n\" Remap keys for applying codeAction to the current buffer.\nnmap <leader>ac  <Plug>(coc-codeaction)\n\" Apply AutoFix to problem on the current line.\nnmap <leader>ca  <Plug>(coc-fix-current)\n\n\" Run the Code Lens action on the current line.\nnmap <leader>cl  <Plug>(coc-codelens-action)\n\" formatting\nnmap <leader>ff <plug>(coc-format)\n\nlet g:coc_start_at_startup = 1\ninoremap <silent><expr> <c-space> coc#refresh()\n\"enable or disable coc\ncnoreabbrev <expr> dd  getcmdtype() == \":\" && getcmdline() == \"dd\" ? \"CocDisable\" : \"dd\"\ncnoreabbrev <expr> de  getcmdtype() == \":\" && getcmdline() == \"de\" ? \"CocEnable\" : \"de\"\n\n\" use <tab> for trigger completion and navigate to the next complete item\nfunction! s:check_back_space() abort\n\tlet col = col('.') - 1\n\treturn !col || getline('.')[col - 1]  =~ '\\s'\nendfunction\n\ninoremap <expr> <Tab> pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"\ninoremap <expr> <S-Tab> pumvisible() ? \"\\<C-p>\" : \"\\<S-Tab>\"\n\n\" Use K to show documentation in preview window.\nnnoremap <silent> K :call <SID>show_documentation()<CR>\n\ninoremap <silent><expr> <Tab>\n\t\t\t\\ pumvisible() ? \"\\<C-n>\" :\n\t\t\t\\ <SID>check_back_space() ? \"\\<Tab>\" :\n\t\t\t\\ coc#refresh()\n\t\bcmd\bvim\0", "config", "coc.nvim")
time([[Config for coc.nvim]], false)
-- Config for: lightspeed.nvim
time([[Config for lightspeed.nvim]], true)
try_loadstring("\27LJ\2\n \2\0\0\4\0\t\0\r6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0005\3\a\0=\3\b\2B\0\2\1K\0\1\0\26exit_after_idle_msecs\1\0\2\14unlabeled\3–\15\flabeled\3∏\23\1\0\2\16ignore_case\2\21limit_ft_matches\3Ë\a\nsetup\15lightspeed\frequireú\1nmap s <Plug>Lightspeed_omni_s\n\"omap ; <Plug>Lightspeed_;_ft\n\"nmap ; <Plug>Lightspeed_;_ft\n\"omap , <Plug>Lightspeed_,_ft\n\"nmap , <Plug>Lightspeed_,_ft\n\bcmd\bvim\0", "config", "lightspeed.nvim")
time([[Config for lightspeed.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n∑\3\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0025\3\b\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\14highlight\fdisable\1\4\0\0\nlatex\thelp\rmarkdown\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\1\3\0\0\vphpdoc\23tree-sitter-phpdoc\26incremental_selection\1\0\2\21ensure_installed\ball\17sync_install\1\fkeymaps\1\0\4\19init_selection\15<leader>is\22scope_incremental\15<leader>si\21node_incremental\15<leader>ni\21node_decremental\15<leader>nd\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: vim-slime
time([[Config for vim-slime]], true)
try_loadstring("\27LJ\2\n3\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\ttmux\17slime_target\6g\bvim\0", "config", "vim-slime")
time([[Config for vim-slime]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
