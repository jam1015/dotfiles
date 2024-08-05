require('flit').setup {
--  keys = { f = 'f', F = 'F', t = 't', T = 'T' },
--  -- A string like "nv", "nvo", "o", etc.
--  labeled_modes = "v",
--  multiline = true,
--  -- Like `leap`s similar argument (call-specific overrides).
--  -- E.g.: opts = { equivalence_classes = {} }
--  opts = {}
}


-------- setting up mapping scheme
local opts = { remap = false, silent = true }
local keymap = vim.keymap.set


-------- keymap for pasting from insert mode
keymap("i", "<C-r>", "<C-r><C-p>", opts) -- helps with pasting from insert mode

-------- disable and re-enable keymap in operator-pending mode
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:no",
    callback = function()
        keymap("i", "<C-r>", "<Nop>", opts) -- disable mapping
    end
})

vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "no:*",
    callback = function()
        keymap("i", "<C-r>", "<C-r><C-p>", opts) -- re-enable mapping
    end
})
