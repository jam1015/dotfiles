-- plugin_configs.themery
local themery = require('themery')
require("themery").setup({
  themes = vim.fn.getcompletion("", "color"),
  livePreview = true
})
