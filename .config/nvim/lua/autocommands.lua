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



-- terminal related --------------------

local my_term_autocmds = api.nvim_create_augroup("my_nvim_terminal", { clear = true })


local function no_term_num()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_get_option_value( 'buftype', {buf = bufnr})
  if buftype == 'terminal' then
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  else
  end
end

api.nvim_create_autocmd("TermOpen", {
  callback = no_term_num,
  group = my_term_autocmds,
})

local function close_after_term()
    -- Defer a little to allow any new buffer to settle in
    vim.defer_fn(function()
      local buffers = vim.api.nvim_list_bufs()
      local listed = {}
      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted",{buf = buf}) then
          table.insert(listed, buf)
        end
      end

      -- If only one buffer is listed and it's unnamed, exit Vim
      if #listed == 1 and vim.api.nvim_buf_get_name(listed[1]) == "" then
        vim.cmd("qa!")
      end
    end, 100)
  end

vim.api.nvim_create_autocmd("TermClose", {
  callback = close_after_term,
  group = my_term_autocmds
})




local function enterternmode()
  if vim.fn.mode() == 'n' then -- and not vim.b.splitting_term then
    vim.cmd([[startinsert]])
  end
end


api.nvim_create_autocmd("TermOpen", {
  callback = enterternmode,
  group = my_term_autocmds,
})

if vim.version.lt(vim.version(), {0, 10, 0}) then
  vim.cmd([[colorscheme blue]])
  vim.api.nvim_create_autocmd({ 'TermClose' }, {
    group = my_term_autocmds,
    desc = 'Automatically close terminal buffers when started with no arguments and exiting without an error',
    callback = function(args)
      if vim.v.event.status == 0 then
        local info = vim.api.nvim_get_chan_info(vim.bo[args.buf].channel)
        local argv = info.argv or {}
        if #argv == 1 and argv[1] == vim.o.shell then
          vim.cmd({ cmd = 'Bdelete', args = { args.buf }, bang = true })
        end
      end
    end,
  })
end

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
