;;; -*- lexical-binding: t; -*-
(use-package god-mode
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (my/mappings-god-mode))
(provide 'god-mode-config)
;;;end god-mode-config.el
