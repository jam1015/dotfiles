local api = vim.api

-- Highlight on yank
local function hilite()
  vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
end

local aesthetics = api.nvim_create_augroup("aesthetic_settings", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
  callback = hilite,
  group = aesthetics,
})

-- concurrency ----------------------------


local concurrent = api.nvim_create_augroup("concurrent_editing", { clear = true })

local function set_concurrent() --lets you edit multiple files at the same time
  -- Variable exists and is true
  vim.v.swapchoice = "e"
  require("notify")("concurrent editing", vim.log.levels.WARN,
    { timeout = 1000, animate = false, render = "minimal", })
end

api.nvim_create_autocmd("SwapExists", {
  callback = set_concurrent,
  group = concurrent,
})

-- to check if we want to reload the file
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  -- needed because checktieme doesn't work in command line window
  command = "if mode() != 'c' &&  expand('%') !=# '[Command Line]' | checktime | endif",
  pattern = { "*" },
  group = concurrent
})

vim.api.nvim_create_autocmd({ "FileChangedShellPost" },
  {
    command =
    'execute \'echohl WarningMsg | echo "File " . fnameescape(expand("<afile>")) . " changed on disk. Buffer reloaded." | echohl None\'',
    pattern = { "*" },
    group = concurrent
  })





-- Create or clear an autocmd group for this purpose


---- Create the TermOpen autocmd
--vim.api.nvim_create_autocmd("TermOpen", {
--	group = my_term_autocmds,
--  desc = "normal mode command to close terminal",
--	-- No pattern is needed; TermOpen inherently targets terminal buffers
--	callback = function(args)
--		-- Directly apply the mapping to the opened terminal buffer
--		vim.api.nvim_buf_set_keymap(args.buf, 'n', 'q', '<cmd>Bdelete!<CR>', {
--			-- Make the mapping silent and buffer-local
--			silent = true,
--			noremap = true,
--			nowait = true,
--		})
--	end,
--})

--api.nvim_create_autocmd("TermClose", {
--	pattern = "*",
--	command = "if !v:event.status | exe 'Bdelete! '..expand('<abuf>') | endif",
--
--	--command = "if !v:event.status && len(getbufline(expand('<abuf>'), 1, '$')) == 0 | exe 'bdelete! '..expand('<abuf>') | endif",
--	--command = "if !v:event.status | exe 'Bdelete!' | endif",
--	group = my_term_autocmds
--})

-- showcmd related ----------------
-- Set 'showcmd' when entering any visual mode
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:[vV\x16]*",
  callback = function()
    vim.opt.showcmd = true
  end,
})

-- Unset 'showcmd' when leaving any visual mode
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "[vV\x16]*:*",
  callback = function()
    vim.opt.showcmd = false
  end,
})



require('term_autocmds')


--vim.api.nvim_create_autocmd("ModeChanged", {
--    pattern = "*",
--    callback = function(args)
--        -- Check if entering any visual mode (v, V, or Ctrl-V)
--        if args.new_mode:match("^v") then
--            vim.opt.showcmd = true
--        else
--            vim.opt.showcmd = false
--        end
--    end,
--})

-- clipboard ---------------------------

--local clipboard_acg = api.nvim_create_augroup("cb_autocmds", { clear = true })

--api.nvim_create_autocmd("FocusLost", {
--	callback = function() vim.opt.clipboard = "" end,
--	group = clipboard_acg,
--})
--
--api.nvim_create_autocmd("FocusGained", {
--	callback = function() vim.opt.clipboard = "unnamedplus" end,
--	group = clipboard_acg,
--})
