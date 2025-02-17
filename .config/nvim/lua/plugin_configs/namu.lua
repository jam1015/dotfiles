require("namu").setup(
  {

    namu_symbols = {
      enable = true,
      options = {
        -- symbol navigation options
      }
    },
    ui_select = {
      enable = true,
      options = {
        -- ui select options
      }
    },
    colorscheme = {
      enable = true,
      options = {
        persist = false,     -- Remember selected colorscheme
        write_shada = false, -- For multiple nvim instances
      }
    },
  }
)
