local function vcs_root_dir_name()
  local buftype = vim.bo.buftype
  local modifiable = vim.bo.modifiable
  local vcs_icon_exists = vim.b.vcs_icon ~= nil
  local vcs_base_icon_exists = vim.b.vcs_base_icon ~= nil

  -- Exclude special buffers and check for the absence of specific variables
  if modifiable and buftype == '' and not vcs_icon_exists and not vcs_base_icon_exists then
    -- Get the full path of the current file
    local filepath = vim.fn.expand('%:p:h')
    if filepath == "" or filepath == nil then
      return
    end

    local vcs_sys = {
      git = { command = "git -C " .. filepath .. " rev-parse --show-toplevel 2> /dev/null", icon = "󰊢" },
      hg  = { command = "hg --cwd " .. filepath .. " root 2> /dev/null", icon = "☿" },
      svn = { command = "svn info --show-item wc-root " .. filepath .. " 2> /dev/null", icon = "𝕊" },
    }

    local function on_exit(vcs_key, job_id, data)
      if data and #data > 0 then
        local root = table.concat(data, "\n"):gsub("\n$", "")
        local base_dir_name = root:match("([^/\\]+)$")
        if base_dir_name and base_dir_name ~= "" then
          vim.b.vcs_base_dir = base_dir_name
          vim.b.vcs_icon = vcs_sys[vcs_key].icon
          vim.schedule(function() require('lualine').refresh() end)
        end
      end
    end

    for key, sys in pairs(vcs_sys) do
      vim.fn.jobstart(sys.command, {
        on_stdout = function(job_id, data)
          on_exit(key, job_id, data) -- 'key' is passed directly
        end,
        on_stderr = function(job_id, data)
          on_exit(key, job_id, data) -- 'key' is passed directly
        end,
        stdout_buffered = true,
        stderr_buffered = true
      })
    end
  end
end

vim.api.nvim_create_augroup("mylualine", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, { group = "mylualine", callback = vcs_root_dir_name })
-- ~/.config/nvim/lua/plugin_configs/lualine/my_auto_theme.lua
