" basic vimrc taken from https://dash9.dev/posts/nvim-1/
source ~/.config/nvim/my_config_files/premade.vim
if has('nvim')
else
source ~/.vim/my_config_files/other_base_vim.vim
endif "for having nvim
"---- personal virc----------------------
" mapping keys

" setting other settings
source ~/.config/nvim/my_config_files/my_mappings.vim

" loading plugins
source ~/.config/nvim/my_config_files/minpac_setup.vim
packadd minpac
call minpac#init() "make sure that this is the first plugin initialized
if !exists('g:loaded_minpac')
	echo "minpac not available"
else  	" minpac is available.

		call minpac#add('k-takata/minpac', {'type': 'opt'}) "packadd does it well

		source ~/.config/nvim/my_config_files/vim_colorschemes.vim
		source ~/.config/nvim/my_config_files/vim_plugins.vim

		if has('nvim')

source ~/.config/nvim/my_config_files/nvim_plugins.vim
source ~/.config/nvim/my_config_files/nvim_colorschemes.vim

		else "nvim packages
		endif

endif

source ~/.config/nvim/my_config_files/my_settings.vim

