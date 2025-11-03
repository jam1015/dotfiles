(use-package evil-leader
	     :after evil
	     :config
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "ee" 'eshell
  "bb" 'switch-to-buffer
  "bk" 'kill-buffer)
  "ll"  'evil-search-highlight-persist-remove-all
	     )

(provide 'evil-leader-config)

;;;end evil-leader-config.el
