-- No need to copy this inside `setup()`. Will be used automatically.
require('mini.bracketed').setup( {
  -- First-level elements are tables describing behavior of a target:
  --
  -- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
  --   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
  --   Supply empty string `''` to not create mappings.
  --
  -- - <options> - table overriding target options.
  --
  -- See `:h MiniBracketed.config` for more info.

  buffer     = { suffix = '', options = {} }, --'b'
  comment    = { suffix = '', options = {} }, --'c'
  conflict   = { suffix = '', options = {} }, --'x'
  diagnostic = { suffix = '', options = {} }, --'d'
  file       = { suffix = '', options = {} }, --'f'
  indent     = { suffix = '', options = {} }, --'i'
  jump       = { suffix = '', options = {} }, --'j'
  location   = { suffix = '', options = {} }, --'l'
  oldfile    = { suffix = '', options = {} }, --'o'
  quickfix   = { suffix = '', options = {} }, --'q'
  treesitter = { suffix = 't', options = {} }, --'t'
  undo       = { suffix = '', options = {} }, --'u'
  window     = { suffix = '', options = {} }, --'w'
  yank       = { suffix = '', options = {} }, --'y'
})
