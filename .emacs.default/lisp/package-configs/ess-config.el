;;; -*- lexical-binding: t; -*-
(use-package ess
  :ensure (ess
           :build ((:before elpaca-build-link +elpaca/build-step-make-doc)
                   (:not elpaca-build-docs))
           :files (:defaults "doc/info/*.info" "doc/info/dir"
                             "etc" "lisp" "obsolete"))
  :defer t
  :commands (R R-mode ess-mode)
  :init
  (setq ess-style 'RStudio
        ess-eval-visibly 'nowait))

(provide 'ess-config)
;;; end ess-config.el
