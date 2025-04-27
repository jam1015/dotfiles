require("bluloco").setup({
  style = "auto",               -- "auto" | "dark" | "light"
  transparent = false,
  italics = true,
  terminal = true, --vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
  guicursor = true,
  rainbow_headings = true,     -- if you want different colored headings for each heading level
})

