(use-package wgrep
  :after grep
  :custom
  (wgrep-auto-save-buffer t)
  :config
  (my/mappings-wgrep))

(provide 'wgrep-config)
;;;end wgrep-config.el
