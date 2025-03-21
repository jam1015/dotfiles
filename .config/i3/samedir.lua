local function nvide_terminal()
  if #arg == 0 then
    local file_path = vim.fn.expand("~/.local/state/zsh/whereami")
    local lines = vim.fn.readfile(file_path)
    if lines and #lines > 0 then
      local new_dir = lines[1]
      vim.cmd("cd " .. new_dir)
    end
    vim.cmd([[
    terminal
    norm a
    ]])
  end
end

local nvide = vim.api.nvim_create_augroup("neovide_terminal", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = nvide_terminal,
  group = nvide,
})

