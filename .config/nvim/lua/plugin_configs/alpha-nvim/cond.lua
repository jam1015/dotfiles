return function()
			local should_skip = false
			if vim.fn.argc() > 0 or vim.fn.line2byte "$" ~= -1 or not vim.o.modifiable then
				should_skip = true
			else
				for _, arg in pairs(vim.v.argv) do
					if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
						should_skip = true
						break
					end
				end
			end
			return not should_skip
end
