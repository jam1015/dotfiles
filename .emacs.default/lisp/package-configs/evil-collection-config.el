;;; -*- lexical-binding: t; -*-
(use-package evil-collection
  :after evil which-key
  :custom
  (evil-collection-repl-submit-state 'insert)
  :config
  (setq evil-overriding-maps nil)
  (evil-collection-init)
  (my/mappings-unimpaired))
(provide 'evil-collection-config)
;;;end evil-collection-config.el



;(use-package evil-collection
;  :after evil which-key
;  
;  :config
;  (setq evil-overriding-maps nil)
;  (evil-collection-init)
;  )
;(provide 'evil-collection-config)
;;;;end evil-collection-config.el
