(use-package kkp
  :ensure t
  :config
  (defun my/maybe-enable-kkp (frame)
    "Enable KKP mode for terminal frames."
    (unless (display-graphic-p frame)
      (with-selected-frame frame
        (global-kkp-mode +1))))

  (add-hook 'after-make-frame-functions #'my/maybe-enable-kkp)

  ;; Handle initial frame if Emacs started in a terminal
  (unless (display-graphic-p)
    (global-kkp-mode +1))
  (my/mappings-kkp))

(provide 'kkp-config)
;;;end kkp-config.el
