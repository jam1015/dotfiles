(use-package evil-leader
	     :after evil
	     :config
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "ee" 'eshell
  "bb" 'switch-to-buffer
  "bk" 'kill-buffer)
	     )

(provide 'evil-leader-config)

;;;end evil-leader-config.el
