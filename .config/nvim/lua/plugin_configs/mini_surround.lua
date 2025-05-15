require("mini.surround").setup({
  -- use vim-surround–style prefixes before "s"
  mappings = {
    add            = "ys", -- you surround (vim: ys)
    delete         = "ds", -- delete surround (vim: ds)
    replace        = "cs", -- change surround (vim: cs)
    find           = "fs", -- extra: find surround to the right
    find_left      = "fS", -- extra: find surround to the left
    highlight      = "hs", -- extra: briefly highlight surround
    update_n_lines = "ns", -- extra: change search radius (n_lines)

    suffix_next    = "n",  -- e.g. fsn, dsn, csn for “next”
    suffix_last    = "l",  -- e.g. fsl, dsl, csl for “previous”
  },

  -- Vim-surround–style fallback (cover, then next):
  search_method = "cover_or_nearest",

  -- keep visual/line-wise behavior off by default
  respect_selection_type = true,

  -- show non-error helpers
  silent = false,

  -- no custom specs by default
  custom_surroundings = nil,
})
