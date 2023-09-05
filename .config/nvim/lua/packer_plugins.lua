-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]


local packerRecompile = vim.api.nvim_create_augroup("packer_recompile", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "packer_plugins.lua",
	command = "source <afile> | PackerSync",
	group = packerRecompile,
})

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("packer failed to load")
	return
end

packer.init({ ensure_dependencies = true })

-- Install your plugins here
return packer.startup(function(use)
	use("wbthomason/packer.nvim")


use 'dhananjaylatkar/cscope_maps.nvim' -- cscope keymaps
use 'folke/which-key.nvim' -- optional [for whichkey hints]
use 'nvim-telescope/telescope.nvim' -- optional [for picker="telescope"]
use 'ibhagwan/fzf-lua' -- optional [for picker="fzf-lua"]
use 'nvim-tree/nvim-web-devicons' -- optional [for devicons in telescope or fzf]

-- load cscope maps
require('cscope_maps').setup()


use({
  "dhananjaylatkar/vim-gutentags",
  --after = "cscope_maps.nvim",
  config = function()
    vim.g.gutentags_modules = {"cscope_maps"} -- This is required. Other config is optional
    vim.g.gutentags_cscope_build_inverted_index_maps = 1
    vim.g.gutentags_cache_dir = vim.fn.expand("~/code/.gutentags")
    vim.g.gutentags_file_list_command = "fd -e c -e h"
    -- vim.g.gutentags_trace = 1
  end,
})



end)
