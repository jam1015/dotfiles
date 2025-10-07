(use-package corfu-terminal
  :ensure t
  :if (not (display-graphic-p))
  :config (corfu-terminal-mode +1))  ; For terminal Emacs

(provide 'corfu-terminal-config)
;;; end corfu terminal config
