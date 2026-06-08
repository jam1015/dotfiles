(use-package highlight-function-calls
  :hook ((emacs-lisp-mode . highlight-function-calls-mode)
         (lisp-mode . highlight-function-calls-mode)
         (scheme-mode . highlight-function-calls-mode)
         (sly-mrepl-mode . highlight-function-calls-mode)
         (slime-repl-mode . highlight-function-calls-mode)))

(provide 'highlight-function-calls-config)
;;;end highlight-function-calls-config.el
