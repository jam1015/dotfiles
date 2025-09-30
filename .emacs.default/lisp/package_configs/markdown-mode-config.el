(use-package markdown-mode
             :defer t
  
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
(provide 'markdown-mode-config)
