;;; -*- lexical-binding: t; -*-
(use-package dirvish
  :after dired
  :init
  

  :config
  ;; override vanilla Dired
  (dirvish-override-dired-mode)





  ;; extras for layout-switch/toggle commands
  (require 'dirvish-extras))   ;; L = switch layouts, T = toggle preview
(provide 'dirvish-config)
;;;end dirvish-config.el
