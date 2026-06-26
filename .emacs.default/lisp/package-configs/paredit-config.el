(use-package paredit
  :hook ((emacs-lisp-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          clojure-mode
          eval-expression-minibuffer-setup
          ielm-mode) . enable-paredit-mode))

(provide 'paredit-config)
;;;end markdown-mode-config.el
