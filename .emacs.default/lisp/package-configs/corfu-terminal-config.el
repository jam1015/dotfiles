(use-package corfu-terminal
  :ensure t
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode +1)
  (advice-add 'corfu--popup-show :before-while
              (lambda (pos &rest _) (not (null pos)))))

(provide 'corfu-terminal-config)
;;; end corfu terminal config
