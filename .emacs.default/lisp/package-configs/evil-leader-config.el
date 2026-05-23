(use-package evil-leader
  :after evil
  :config
  (global-evil-leader-mode)
  (my/apply-package-mappings 'evil-leader))

(provide 'evil-leader-config)

;;;end evil-leader-config.el
