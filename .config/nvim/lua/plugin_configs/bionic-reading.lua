require('bionic-reading').setup({
      -- determines if the file types below will be
      -- automatically highlighted on buffer open
      auto_highlight = false,
      -- the file types you want to highlight with
      -- the node types you would like to target
      -- using treesitter
      file_types = {
        ["markdown"] = {"any"},
        ["md"] = {"any"},
        ["text"] = {
            "any", -- highlight any node
        },
        -- EX: only highlights comments in lua files
        ["lua"] = {
            "comment",
        },
      },
      -- the highlighting styles applied
      -- IMPORTANT - if link is present, no other
      -- styles are applied
      hl_group_value = {
        link = "Bold",
      },
      -- Flag used to control if the user is prompted
      -- if BRToggle is called on a file type that is not
      -- explicitly defined above
      prompt_user = true,
      -- Enable or disable the use of treesitter
      treesitter = false,
      -- Flag used to control if highlighting is applied as
      -- you type
      update_in_insert_mode = false,
})
