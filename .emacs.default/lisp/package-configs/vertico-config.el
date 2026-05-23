(use-package vertico
  ;;:ensure (:tag "2.8")
  :init
  (vertico-mode)
  (setq completion-styles '(basic substring partial-completion flex))
  :custom
  (vertico-count 15)
  (vertico-resize t)
  (vertico-cycle t)
  :config
  (my/apply-package-mappings 'vertico))
(provide 'vertico-config)
;;;end vertico-config.el
