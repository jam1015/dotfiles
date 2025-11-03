;;;  begin evil-search-hightlihgt-config
(use-package evil-search-highlight-persist
  :ensure t
  :after (evil evil-leader)
  :config
  (global-evil-search-highlight-persist t)

(evil-leader/set-key
  "ll"  'evil-search-highlight-persist-remove-all
	     )





  )

(provide 'evil-search-highlight-persist-config)
;;; end evil-search-hightlihgt-config
