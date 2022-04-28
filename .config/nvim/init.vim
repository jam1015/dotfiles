" basic vimrc taken from https://dash9.dev/posts/nvim-1/
source ~/.config/nvim/my_config_files/premade.vim
source ~/.vim/my_config_files/other_base_vim.vim

"---- personal virc----------------------|

" setting other settings
source ~/.config/nvim/my_config_files/my_mappings.vim

lua require('plugins') -- ~/.config/nvim/lua/plugins.lua

source ~/.config/nvim/my_config_files/my_settings.vim

