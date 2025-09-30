(use-package flycheck
  :defer t
  :init
  ;;(global-flycheck-mode)
  :config ;;(add-hook 'after-init-hook #'global-flycheck-mode)
 ;; optional
  ;;(setq flycheck-disabled-checkers '(emacs-lisp emacs-lisp-ela))
 (flycheck-add-mode 'emacs-lisp-checkdoc 'emacs-lisp-mode)
 :hook ((prog-mode       . flycheck-mode)
          (emacs-lisp-mode . flycheck-mode))
  )
(provide 'flycheck-config)
