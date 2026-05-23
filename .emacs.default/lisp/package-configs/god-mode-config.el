(use-package god-mode
  :ensure (:host github
           :repo "emacsorphanage/god-mode"
           :build (:sub elpaca--clone +elpaca/build-if-new)
           )
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (my/apply-package-mappings 'god-mode))
(provide 'god-mode-config)
;;;end god-mode-config.el
