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
  if vim.fn.mode() == 'n' then -- and not vim.b.splitting_term then
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

