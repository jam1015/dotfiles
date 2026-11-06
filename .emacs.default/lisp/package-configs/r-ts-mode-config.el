;;; -*- lexical-binding: t; -*-
(use-package r-ts-mode
  :ensure (:host codeberg :repo "R-for-emacs/r-ts-mode")
  :mode (("\\.R\\'" . r-ts-mode)
         ("\\.r\\'" . r-ts-mode)))

(provide 'r-ts-mode-config)
;;; end r-ts-mode-config.el
