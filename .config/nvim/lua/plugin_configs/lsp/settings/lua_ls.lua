local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
-- Get the directory of the currently opened file
local current_file_dir = vim.fn.expand('%:p:h')
return {
  on_init = function(client)
    --print("Initializing client...")

    -- Print workspace folders
    local hasLuarcJson = false
    local hasLuarcJsonc = false
    if client.workspace_folders and #client.workspace_folders > 0 then
      for i, folder in ipairs(client.workspace_folders) do
        if folder and folder.name and folder.uri then
          print("LuaLS Workspace folder " .. i .. ": " .. folder.name .. ", URI: " .. folder.uri)
        end
      end
      local path = client.workspace_folders[1].name
      --print("Checking for config files in: " .. path)

       hasLuarcJson = vim.loop.fs_stat(path .. '/.luarc.json') ~= nil
       hasLuarcJsonc = vim.loop.fs_stat(path .. '/.luarc.jsonc') ~= nil
    else
      print("No LuaLS workspace folders available.")
    end



    --print(".luarc.json exists: " .. tostring(hasLuarcJson))
    --print(".luarc.jsonc exists: " .. tostring(hasLuarcJsonc))

    if not hasLuarcJson and not hasLuarcJsonc then
      print("No LuaLS config files found. Setting up default configurations.")

      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        -- Your settings here
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      --print("Configurations updated.")
    end

    --print("Client initialized.")
    return true
  end,
  settings = {
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT',
      -- Setup your lua path
      path = runtime_path,
    },

    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          --vim.env.VIMRUNTIME,
          [current_file_dir] = true,
          -- these were causing problems and I'm not sure why they're there
          --vim.api.nvim_get_runtime_file('', true),
          --"${3rd}/luassert/library",
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
        checkThirdParty = false,
        --library = {
        --	  -- Make the server aware of Neovim runtime files
        --},
      },
      telemetry = {
        enable = false,
      },

      semantic = { enable = false },
    },

  },
}
