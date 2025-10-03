(use-package dashboard
  :if (< (length command-line-args) 2)
  :disabled t
  :init
  (require 'cl-lib)
  :config

  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))

(provide 'dashboard-config)
;;;end dashboard-config.el
