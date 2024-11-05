require 'nvim-treesitter.configs'.setup {
  ignore_install = {},
  modules = {},
  auto_install = false,
  incremental_selection = {
    enable = true,
    keymaps = {
      --init_selection = '<TAB>',
      --scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { "vimdoc", "markdown_inline", "markdown", "vim", "r", "rnoweb", "lua", "c", "python", "html", "typescript", "javascript", "bash", "make",
    "commonlisp", "json" },
  autopairs = true,
  autotag = { enable = true },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  -- ignore_install = { "javascript" },

  textobjects = { enable = true },
  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "vimdoc"},--  "markdown" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  matchup = { enable = true, disable = { "markdown" } },
  -- ...
}
