;;; -*- lexical-binding: t; -*-
(use-package markdown-mode
             :defer t
  
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package markdown-toc
  :after markdown-mode)

(provide 'markdown-mode-config)
;;;end markdown-mode-config.el
