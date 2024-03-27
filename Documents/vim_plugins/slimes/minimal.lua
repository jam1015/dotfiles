local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup(

	{
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-neotest/nvim-nio",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
				"nvim-neotest/neotest-python",
				"nvim-neotest/neotest-plenary",
				"nvim-neotest/neotest-vim-test"
			},
			config = function()
				require("neotest").setup({
					adapters = {
						require("neotest-python")({
							dap = { justMyCode = false },
						}),
						require("neotest-plenary"),
					},
				})
			end
		},
		{ 'akinsho/toggleterm.nvim', version = "*", config = true },
		{ 'chengzeyi/multiterm.vim', enabled = true },
		{
			"jam1015/vim-slime",
			dir = "~/Documents/vim_plugins/slimes/vim-slime",
			init = function()
				require("plugin_configs.vim-slime.initi")


				if os.getenv("TMUX") then
					vim.g.slime_target = "tmux"
					vim.notify("using tmux")

					--vim.g.slime_default_config = { socket_name = "default", target_pane = "{next}" }
				else
					vim.g.slime_target = "neovim"
					vim.g.slime_no_mappings = true
					vim.g.slime_input_pid = false
					vim.g.slime_suggest_default = true


					vim.g.slime_menu_config = false
				end
			end,

			config = function()
				local keymap = vim.keymap.set
				keymap("n", "gz", "<Plug>SlimeMotionSend", { remap = true, silent = false })
				keymap("n", "gzz", "<Plug>SlimeLineSend", { remap = true, silent = false })
				keymap("x", "gz", "<Plug>SlimeRegionSend", { remap = true, silent = false })
			end,
		},
		{
			"pappasam/nvim-repl",
			enabled = false,
			--dir = "~/Documents/vim_plugins/nvim-repl",
			init = function()
				vim.g["repl_filetype_commands"] = {
					javascript = "node",
					python = "ipython --no-autoindent"
				}
			end,
			keys = {
				{ "<leader>rt", "<cmd>ReplToggle<cr>",  desc = "Toggle nvim-repl" },
				{ "<leader>rc", "<cmd>ReplRunCell<cr>", desc = "nvim-repl run cell" },
			},
		}
	}

)




vim.cmd([[


let g:slime_neovim_menu_delimiter = " | "
let g:slime_neovim_menu_order = [{'pid': 'pid: '},{'term_title':''},{'name':''},{'jobid':'zebra: '}]
let g:slime_neovim_ignore_unlisted = 1

function! WriteFormattedBufInfo()
    " Get buffer info and convert to JSON string
    let bufinfo_json = json_encode(getbufinfo())

    " Write to a temporary file
    let tmpfile = tempname()
    call writefile([bufinfo_json], tmpfile)

    " Format JSON using jq and write to a desired file
    let output_file = 'buffer_info_formatted.json'
    let command = 'jq . ' . shellescape(tmpfile) . ' > ' . shellescape(output_file)
    call system(command)

    " Optionally, delete the temporary file
    call delete(tmpfile)
endfunction


function Safe_jobpid(channel_in)
	let pid_out = ""
	try
		let pid_out = string(jobpid(a:channel_in))
		" in case an external process kills the terminal's shell
	catch /^Vim\%((\a\+)\)\=:E900/
	endtry
	return pid_out
endfunction

autocmd TermOpen * setlocal statusline=%{bufname()}%=id:\ %{&channel}\ pid:\ %{Safe_jobpid(&channel)}
autocmd TermClose * call WriteFormattedBufInfo()
autocmd TermOpen * call WriteFormattedBufInfo()

echo "used minimal config"

nnoremap gve :call slime#targets#neovim#ValidEnv()<CR>
nnoremap gef :call slime#targets#neovim#FakeFunction()<CR>
nnoremap gex :call slime#targets#neovim#ExampleFunction()<CR>
nnoremap gvv :call CallValidEnvIfExists()<CR>




" Function to safely check for b:slime_config and return the jobid
function! GetSlimeJobId()
  if exists("b:slime_config") && type(b:slime_config) == v:t_dict && has_key(b:slime_config, 'jobid') && !empty(b:slime_config['jobid'])
    return ' | jobid: ' . b:slime_config['jobid'] . ' '
  endif
	redraw
  return ''
endfunction

" Function to safely check for b:slime_config and return the pid
function! GetSlimePid()
  if exists("b:slime_config") && type(b:slime_config) == v:t_dict && has_key(b:slime_config, 'pid') && !empty(b:slime_config['pid'])
    return 'pid: ' . b:slime_config['pid']
  endif
	redraw
  return ''
endfunction


"default statuslin with :set ruler
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" Append the custom function outputs to the right side of the status line, with " | " as a separator
set statusline+=%{GetSlimeJobId()}%{GetSlimePid()}




]])

--vim.g.slime_get_jobid = function()
--  -- some way to select and return jobid
--  return 3
--end
