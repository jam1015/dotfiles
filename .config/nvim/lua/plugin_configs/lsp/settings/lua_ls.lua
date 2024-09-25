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
      for _, folder in ipairs(client.workspace_folders) do
        if folder and folder.name and folder.uri then
          print("LuaLS URI: " .. folder.uri)
        end
      end
      local path = client.workspace_folders[1].name
      --print("Checking for config files in: " .. path)

       hasLuarcJson = (vim.uv or vim.loop).fs_stat(path .. '/.luarc.json') ~= nil
       hasLuarcJsonc = (vim.uv or vim.loop).fs_stat(path .. '/.luarc.jsonc') ~= nil
    else
      print("No LuaLS workspace folders available.")
    end



    --print(".luarc.json exists: " .. tostring(hasLuarcJson))
    --print(".luarc.jsonc exists: " .. tostring(hasLuarcJsonc))

    if not hasLuarcJson and not hasLuarcJsonc then
      --print("No LuaLS config files found. Setting up default configurations.")

      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        -- Your settings here
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      --print("Configurations updated.")
    end

    --print("Client initialized.")
    return true
  end,
  settings = {},
}






-- example luar_jsconc
--{
--  "runtime.version": "LuaJIT",
--  "runtime.path": [
--    "lua/?.lua",
--    "lua/?/init.lua"
--  ],
--  "diagnostics.globals": ["vim"],
--  "workspace.checkThirdParty": false,
--  "workspace.library": [
--    "$VIMRUNTIME"
--    //"${3rd}/luv/library"
--    //"${3rd}/busted/library"
--  ]
--}
