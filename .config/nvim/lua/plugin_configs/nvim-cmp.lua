local cmp = require 'cmp'
local has_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
local not_has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col == 0 or vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") --== nil
end

local function output_to_file(tbl, filename)
  local str = vim.inspect(tbl)
  local file = io.open(filename, "a") -- Open the file in append mode
  if file then
    file:write(str)                   -- Write the inspected table as a string
    file:write("\n")                  -- Write a newline character
    file:close()
  else
    error("Could not open file to write")
  end
end

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local in_comment = function()
  local context = require("cmp.config.context")
  return (
    context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
  )
end
local luasnip = require("luasnip") -- Set up nvim-cmp.

local lspkind = require('lspkind')
require("luasnip.loaders.from_vscode").lazy_load()

-- Set the behavior of tab
--vim.cmd([[set completeopt=menu,menuone,noselect]])

cmp.setup({
  view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif not_has_words_before() then
        fallback()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  formatting = {
    expandable_indicator = true,
    fields = { "kind", "abbr", "menu" },
    format = function(outer_entry, outer_vim_item) -- should be a function that returns a completed item
      output_to_file({ "outer item" }, "/home/jordan/cmp_debug.txt")
      output_to_file(outer_vim_item, "/home/jordan/cmp_debug.txt")
      local kind = lspkind.cmp_format({
        -- cmp_format returns a function, and we immediately call it
        mode = "symbol_text",
        maxwidth = 100,
        ellipsis_char = '...',
        before = function(entry, vim_item)
          vim_item.menu = ({ --sets things before
            buffer = "[Buffer]",
            cmp_r = "[cmp-r]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            path = "[Path]",
            latex_symbols = "[Latex]",
          })[entry.source.name]

          return vim_item
        end
      })(outer_entry, outer_vim_item)

      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = strings[1]
      local to_append = ""
      if kind.menu then
        to_append = kind.menu .. ":"
      else
        to_append = ""
      end

      kind.menu = to_append .. strings[2]

      return kind
    end,

  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "latex_symbols", option = { strategy = 2 } },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = "path" },
    { name = "cmp_r" },
  }),
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = "single" -- { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    completion = {
      border = "single" --{ "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    -- completion = cmp.config.window.bordered(),
    --documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = false,
  },
  matching = {
    disallow_fuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
    disallow_symbol_nonprefix_matching = false,
  },

  preselect = cmp.PreselectMode.Item
})

--Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(
    {
      --			['<C-b>'] = cmp.mapping(function(fallback)
      --				vim.cmd([[colorscheme blue]])
      --				if cmp.visible() then
      --					cmp.select_prev_item()
      --				elseif luasnip.jumpable(-1) then
      --					luasnip.jump(-1)
      --				else
      --					fallback()
      --				end
      --			end, { "i", "s", "c" }),

      --	['<C-b>'] = cmp.mapping(function(fallback)
      --		vim.cmd([[colorscheme blue]])
      --		cmp.complete({

      --			config = { sources = { name = 'path' } }

      --		})
      --end, { "i", "s", "c" })
    }),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option =
      {
        ignore_cmds = {
          --	'edit'
        }
      }
    }
  })
})


local cmp_grp = vim.api.nvim_create_augroup("cmp_autocmds", { clear = true }) --similar setup in lazy config
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*.lisp",
  callback = function()
    --require('cmp').setup.buffer { enabled = false }
    require 'cmp'.setup.buffer {
      completion = {
        autocomplete = false
      }
    }
  end,
  group = cmp_grp,
})
if has_autopairs then
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end
require("plugin_keymaps").nvim_cmp()
