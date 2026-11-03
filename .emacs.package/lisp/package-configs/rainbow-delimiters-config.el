(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (sly-mrepl-mode . rainbow-delimiters-mode)
         (slime-repl-mode . rainbow-delimiters-mode)))

(provide 'rainbow-delimiters-config)
;;;end rainbow-delimiters-config.el
