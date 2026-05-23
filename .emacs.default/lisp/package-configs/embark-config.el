(use-package embark
  :demand t
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (my/apply-package-mappings 'embark))


(provide 'embark-config)
;;;end embark-config.el
