;;; -*- lexical-binding: t; -*-
(use-package sly
  ;; Autoloads hook `sly-editing-mode' into lisp-mode; full load on M-x sly.
  :defer t
  :init
  ;(setq inferior-lisp-program "sbcl")
  (setq inferior-lisp-program "clisp")
  :config
  (my/mappings-sly))

(provide 'sly-config)
;;;end sly-config.el
