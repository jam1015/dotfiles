require('nvim-smart-termsplit').setup(
  {
    shell = '/bin/zsh',            -- Custom shell
    enable_cleanup = true,         -- Auto-close terminal buffers
    fallback_to_home = true,       -- Use home dir if pwd detection fails
    debug = false,                 -- Enable debug logging
  }
)
