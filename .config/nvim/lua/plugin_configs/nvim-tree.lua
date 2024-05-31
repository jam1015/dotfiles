local nvt = require("nvim-tree")
require("nvim-tree").setup { -- BEGIN_DEFAULT_OPTS
  on_attach = "default",
  hijack_cursor = false,
  auto_reload_on_write = true,
  disable_netrw = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  root_dirs = {},
  prefer_startup_root = false,
  sync_root_with_cwd = false,
  reload_on_bufenter = false,
  respect_buf_cwd = false,
  select_prompts = false,
  sort = {
    sorter = "name",
    folders_first = true,
    files_first = false,
  },
  view = {
    centralize_selection = false,
    cursorline = true,
    debounce_delay = 15,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    width = 30,
    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 30,
        height = 30,
        row = 1,
        col = 1,
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    full_name = false,
    root_folder_label = ":~:s?$?/..?",
    indent_width = 2,
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    symlink_destination = true,
    highlight_git = "none",
    highlight_diagnostics = "none",
    highlight_opened_files = "none",
    highlight_modified = "none",
    highlight_bookmarks = "none",
    highlight_clipboard = "name",
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      web_devicons = {
        file = {
          enable = true,
          color = true,
        },
        folder = {
          enable = false,
          color = true,
        },
      },
      git_placement = "before",
      modified_placement = "after",
      diagnostics_placement = "signcolumn",
      bookmarks_placement = "signcolumn",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        modified = true,
        diagnostics = true,
        bookmarks = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "󰆤",
        modified = "●",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_root = false,
    ignore_list = {},
  },
  system_open = {
    cmd = "",
    args = {},
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    disable_for_dirs = {},
    timeout = 400,
    cygwin_support = false,
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  modified = {
    enable = false,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },
  filters = {
    enable = true,
    git_ignored = true,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    no_bookmark = false,
    custom = {},
    exclude = {},
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {},
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
      exclude = {},
    },
    file_popup = {
      open_win_config = {
        col = 1,
        row = 1,
        relative = "cursor",
        border = "shadow",
        style = "minimal",
      },
    },
    open_file = {
      quit_on_open = false,
      eject = true,
      resize_window = true,
      window_picker = {
        enable = true,
        picker = "default",
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },
  trash = {
    cmd = "gio trash",
  },
  tab = {
    sync = {
      open = false,
      close = false,
      ignore = {},
    },
  },
  notify = {
    threshold = vim.log.levels.INFO,
    absolute_path = true,
  },
  help = {
    sort_by = "key",
  },
  ui = {
    confirm = {
      remove = true,
      trash = true,
      default_yes = false,
    },
  },
  experimental = {},
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      dev = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
} -- END_DEFAULT_OPTS

-- abbreviation
local cabbrev_cmds = require("cabbrev_fun")
cabbrev_cmds.cabbrev("nvt", "NvimTreeOpen")

---- old code ------------------

--local nvtc = require("nvim-tree.config")
--local tree_cb = nvtc.nvim_tree_callback
--		mappings = {
--			custom_only = false,
--			list = {
--            { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
--            { key = "h", action_cb = tree_cb "close_node" },
--            { key = "v", action_cb = tree_cb "vsplit" },
--            { key = "H", action_cb = tree_cb "ssplit" },
--				-- user mappings go here
--			},
--		},

---- Shorten function name

--cabbrev_cmds.cabbrev("Explore", "NvimTreeOpen")

-- auto close
--local function tab_win_closed(winnr)
--	local api = require "nvim-tree.api"
--	local tabnr = vim.api.nvim_win_get_tabpage(winnr)
--	local bufnr = vim.api.nvim_win_get_buf(winnr)
--	local buf_info = vim.fn.getbufinfo(bufnr)[1]
--	local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
--	local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
--	if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
--		-- Close all nvim tree on :q
--		if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
--			api.tree.close()
--		end
--	else -- else closed buffer was normal buffer
--		if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
--			local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
--			if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
--				vim.schedule(function()
--					if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
--						vim.cmd "quit" -- then close all of vim
--					else -- else there are more tabs open
--						vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
--					end
--				end)
--			end
--		end
--	end
--end
--
--vim.api.nvim_create_autocmd("WinClosed", {
--	callback = function()
--		local winnr = tonumber(vim.fn.expand("<amatch>"))
--		vim.schedule_wrap(tab_win_closed(winnr))
--	end,
--	nested = true
--})
