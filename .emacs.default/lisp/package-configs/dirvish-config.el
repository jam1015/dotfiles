(use-package dirvish
  :after dired
  :init
  

  :config
  ;; override vanilla Dired
  (dirvish-override-dired-mode)





  ;; extras for layout-switch/toggle commands
  (require 'dirvish-extras)   ;; L = switch layouts, T = toggle preview

  (use-package all-the-icons :defer t)

  )
(provide 'dirvish-config)
;;;end dirvish-config.el
