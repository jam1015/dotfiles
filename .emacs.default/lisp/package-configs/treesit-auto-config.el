(use-package treesit-auto
  :ensure (:host github :repo "renzmann/treesit-auto")
  :config
  (setq treesit-auto-install t)  ; Install without asking
  (setq treesit-font-lock-level 4)  ; Maximum highlighting
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(provide 'treesit-auto-config)

;;; end treesit-auto-config.el
