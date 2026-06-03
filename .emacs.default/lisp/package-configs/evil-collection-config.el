(use-package evil-collection
  :ensure (:host github
           :repo "jam1015/evil-collection"
           :branch "master"
           :build (:sub elpaca--clone +elpaca/build-if-new)
           )
  :after evil which-key
  :config
  (setq evil-overriding-maps nil)
  (evil-collection-init))
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
