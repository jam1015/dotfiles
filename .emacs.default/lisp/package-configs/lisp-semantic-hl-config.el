(use-package lisp-semantic-hl
  :load-path "/home/jordan/emacs-packages/mainline/lisp-semantic-hl.el/"
  :hook ((emacs-lisp-mode . lisp-semantic-hl-mode)
         (lisp-interaction-mode . lisp-semantic-hl-mode)
         (lisp-mode . lisp-semantic-hl-mode)))

(provide 'lisp-semantic-hl-config)
;;;end lisp-semantic-hl-config.el
