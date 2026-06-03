(use-package sly
  :init
  ;(setq inferior-lisp-program "sbcl")
  (setq inferior-lisp-program "clisp")
  :config
  (my/mappings-sly))

(provide 'sly-config)
;;;end sly-config.el
