-- Attempt to load the custom lualine theme.
--local ok, my_custom_theme = pcall(require, 'plugin_configs.lualine.my_auto_theme')

local used_theme = nil
if nil then
  used_theme = my_custom_theme('normal')
  --vim.cmd([[colorscheme delek]])
else
  used_theme = 'auto'
  --vim.cmd([[colorscheme blue]])
end

-- For getting terminal configuration info.
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
  return vim.api.nvim_eval('&channel > 0 ? jobpid(&channel) : ""')
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

--- Concurrency for lualine --
local lualine_concurrent = vim.api.nvim_create_augroup("concurrent_lualine", { clear = true })

local function set_concurrent_lualine()
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
  if vim.b.has_swap then
    -- You can change the return value (e.g., a special character) if desired.
    return ""
  else
    return ""
  end
end

--- Custom function to display a star (U+26E4) in the statusline if the buffer
--- is the marked terminal. Returns the star if true or an empty string otherwise.
local function lualine_marked_terminal_star()
  if vim.b.is_main_terminal then
    return "⛧" --
  else
    return ""
  end
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = used_theme or 'auto',
    -- Component and section separators
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
      statusline = 10,
      tabline = 10,
      winbar = 10,
    }
  },

  sections = {
    -- Include checkSwapFile and our new star function in lualine_a.
    lualine_a = { checkSwapFile },
    lualine_b = {
      { 'branch', padding = { left = 0, right = 0 }, icon = "⎇" },
      { 'diff', padding = { left = 1, right = 0 } },
      { 'diagnostics', padding = { left = 1, right = 0 } }
    },
    lualine_c = {
      { "b:vcs_base_dir", icon = vim.b.vcs_icon },
      { '%f',             padding = { left = 0, right = 0 } }
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', get_chan_jobid, get_chan_jobpid, get_slime_config, lualine_marked_terminal_star }
  },
  inactive_sections = {
    lualine_a = { checkSwapFile},
    lualine_b = {
      { 'branch', padding = { left = 0, right = 0, }, icon = "⎇" },
      { 'diff', padding = { left = 1, right = 0 } },
      { 'diagnostics', padding = { left = 1, right = 0 } }
    },
    lualine_c = {
      { "b:vcs_base_dir", icon = vim.b.vcs_icon },
      { '%f',             padding = { left = 0, right = 0 } }
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', get_chan_jobid, get_chan_jobpid, get_slime_config, lualine_marked_terminal_star }
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
