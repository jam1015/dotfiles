;;;  begin evil-search-hightlihgt-config
(use-package evil-search-highlight-persist
  :ensure t
  :after (evil evil-leader)
  :config
  (global-evil-search-highlight-persist t)
  (my/apply-package-mappings 'evil-search-highlight-persist)

  )

(provide 'evil-search-highlight-persist-config)
;;; end evil-search-hightlihgt-config
