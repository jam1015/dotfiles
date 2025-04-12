-- terminal related --------------------
local api = vim.api

local my_term_autocmds = api.nvim_create_augroup("my_nvim_terminal", { clear = true })


local function no_term_num()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
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
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
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
  --  local ok, is_marked = pcall(vim.api.nvim_buf_get_var, bufnr, "is_main_terminal")
  --and not is_marked then -- and not vim.b.splitting_term then
  if vim.fn.mode() == 'n' then
    vim.cmd([[startinsert]])
  end
end

local function disable_list()
  vim.opt_local.list = false
end

if vim.g.neovide then
  api.nvim_create_autocmd("TermOpen", {
    callback = disable_list
  })
end

api.nvim_create_autocmd("TermOpen", {
  callback = enterternmode,
  group = my_term_autocmds,
})


if vim.version.lt(vim.version(), { 0, 10, 0 }) then
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
