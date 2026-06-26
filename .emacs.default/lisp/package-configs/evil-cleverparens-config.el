(use-package evil-cleverparens
  :hook ((emacs-lisp-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          clojure-mode
          ielm-mode) . evil-cleverparens-mode))

(provide 'evil-cleverparens-config)
;;;end evil-cleverparens-config.el
