local lspconfig = require('lspconfig')
local settings = {
	python_root_files = lspconfig.util.root_pattern(unpack({
		'WORKSPACE', -- added for Bazel; items below are from default config
		'pyproject.toml',
		'setup.py',
		'setup.cfg',
		'requirements.txt',
		'Pipfile',
		'pyrightconfig.json',
	}))

}

return settings
