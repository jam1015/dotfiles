(use-package lisp-extra-font-lock
  :hook ((lisp-mode . lisp-extra-font-lock-mode)
         (emacs-lisp-mode . lisp-extra-font-lock-mode)
         (scheme-mode . lisp-extra-font-lock-mode)
         (sly-mrepl-mode . lisp-extra-font-lock-mode)
         (slime-repl-mode . lisp-extra-font-lock-mode)))

(provide 'lisp-extra-font-lock-config)
;;;end lisp-extra-font-lock-config.el
