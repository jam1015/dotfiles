;;; -*- lexical-binding: t; -*-
(use-package r-ts-mode
  :vc (:url "https://github.com/nverno/r-ts-mode"
       :rev :newest)
  :mode (("\\.R\\'" . r-ts-mode)
         ("\\.r\\'" . r-ts-mode)))

(provide 'r-ts-mode-config)
;;; end r-ts-mode-config.el
