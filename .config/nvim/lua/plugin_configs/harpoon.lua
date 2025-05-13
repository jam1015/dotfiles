-- plugin_configs.harpoon

local M = {}
local harpoon = require("harpoon")
harpoon:setup()
require("plugin_keymaps").harpoon(harpoon)


return M
