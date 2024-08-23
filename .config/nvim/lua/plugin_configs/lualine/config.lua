local ok, my_custom_theme = pcall(require, 'plugin_configs.lualine.my_auto_theme')


local used_theme = nil
if ok then
  used_theme = my_custom_theme('normal')
  --vim.cmd([[colorscheme delek]])
else
  used_theme = 'auto'
  --vim.cmd([[colorscheme blue]])
end

-- for getting terminal configuration info
vim.cmd([[
function! Get_chan_jobid() abort
try
	let out =&channel
	catch
	let out = ""
endtry
return out
endfunction
]])

local function get_chan_jobid()
  return vim.api.nvim_eval('&channel > 0 ? &channel : ""')
end

local function get_chan_jobpid()
  local out = vim.api.nvim_exec2([[
      let pid_out = ""

      try
        let pid_out = string(jobpid(&channel))
        " in case an external process kills the terminal's shell
      catch /^Vim\%((\a\+)\)\=:E900/
      endtry
	]], { output = true })
  return out["output"] --returns as string
end








local function get_slime_config()
  if vim.b.slime_config then
    local result = ""
    for _, value in pairs(vim.b.slime_config) do
      result = result .. tostring(value) .. " "
    end
    return result:match("^%s*(.-)%s*$")
  else
    return ""
  end
end



--- concurency for lualine --
local lualine_concurrent = vim.api.nvim_create_augroup("concurrent_lualine", { clear = true })

local function set_concurrent_lualine() --lets you edit multiple files at the same time
  if vim.v.swapname and vim.v.swapname ~= "" then
    vim.b.has_swap = true
  else
    vim.b.has_swap = false
  end
end

vim.api.nvim_create_autocmd("SwapExists", {
  callback = set_concurrent_lualine,
  group = lualine_concurrent,
})
local function checkSwapFile()
  -- set in the autcmds file
  --vim.api.nvim_exec_autocmds("SwapExists", { group = lualine_concurrent })
  if vim.b.has_swap then
    --return "𝐶"
    return ""
  else
    return ""
  end
end




require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    --'mytheme', --'auto',
    --component_separators = { left = '', right = '' },
    --section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { checkSwapFile },
    lualine_b = { { 'branch', padding = { left = 0, right = 0 }, icon = "⎇" }, { 'diff', padding = { left = 1, right = 0 } }, { 'diagnostics', padding = { left = 1, right = 0 } } },
    lualine_c = { { "b:vcs_base_dir", icon = vim.b.vcs_icon }, { '%f', padding = { left = 0, right = 0 } } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', get_chan_jobid, get_chan_jobpid, get_slime_config}
  },
  inactive_sections = {

    lualine_a = { checkSwapFile },
    lualine_b = { { 'branch', padding = { left = 0, right = 0, }, icon = "⎇" }, { 'diff', padding = { left = 1, right = 0 } }, { 'diagnostics', padding = { left = 1, right = 0 } } },
    lualine_c = { { "b:vcs_base_dir", icon = vim.b.vcs_icon }, { '%f', padding = { left = 0, right = 0 } } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', get_chan_jobid, get_chan_jobpid, get_slime_config}
    --		lualine_a = {},
    --		lualine_b = {},
    --		lualine_c = { 'filename' },
    --		lualine_x = { 'location' },
    --		lualine_y = {},
    --		lualine_z = { 'b:terminal_job_id', 'b:terminal_job_pid' }
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
