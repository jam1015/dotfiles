-- Window layout
-- style 1
-- +----------+------------------------+
-- |          |                        |
-- |          |                        |
-- | undotree |                        |
-- |          |                        |
-- |          |                        |
-- +----------+                        |
-- |          |                        |
-- |   diff   |                        |
-- |          |                        |
-- +----------+------------------------+
-- Style 2
-- +----------+------------------------+
-- |          |                        |
-- |          |                        |
-- | undotree |                        |
-- |          |                        |
-- |          |                        |
-- +----------+------------------------+
-- |                                   |
-- |   diff                            |
-- |                                   |
-- +-----------------------------------+
-- Style 3
-- +------------------------+----------+
-- |                        |          |
-- |                        |          |
-- |                        | undotree |
-- |                        |          |
-- |                        |          |
-- |                        +----------+
-- |                        |          |
-- |                        |   diff   |
-- |                        |          |
-- +------------------------+----------+
-- Style 4
-- +-----------------------++----------+
-- |                        |          |
-- |                        |          |
-- |                        | undotree |
-- |                        |          |
-- |                        |          |
-- +------------------------+----------+
-- |                                   |
-- |                            diff   |
-- |                                   |
-- +-----------------------------------+
vim.g.undotree_WindowLayout = 1

-- e.g. using 'd' instead of 'days' to save some space.
vim.g.undotree_ShortIndicators = 1

-- undotree window width
if vim.g.undotree_ShortIndicators == 1 then
	vim.g.undotree_SplitWidth = 45
else
	vim.g.undotree_SplitWidth = 30
end

-- diff window height
vim.g.undotree_DiffpanelHeight = 10

-- auto open diff window
vim.g.undotree_DiffAutoOpen = 1

-- if set, let undotree window get focus after being opened, otherwise
-- focus will stay in current window.
vim.g.undotree_SetFocusWhenToggle = 0

-- tree node shape.
vim.g.undotree_TreeNodeShape = '*'

-- tree vertical shape.
vim.g.undotree_TreeVertShape = '|'

-- tree split shape.
vim.g.undotree_TreeSplitShape = '/'

-- tree return shape.
vim.g.undotree_TreeReturnShape = '\\'
