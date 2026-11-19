;;; -*- lexical-binding: t; -*-
(use-package lisp-semantic-hl
  :ensure t
  :hook ((emacs-lisp-mode . lisp-semantic-hl-mode)
         (lisp-interaction-mode . lisp-semantic-hl-mode)
         (lisp-mode . lisp-semantic-hl-mode)))

(provide 'lisp-semantic-hl-config)
;;;end lisp-semantic-hl-config.el
