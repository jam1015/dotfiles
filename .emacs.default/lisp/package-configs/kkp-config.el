(use-package kkp
  :ensure t
  :config
  (defun my/maybe-enable-kkp (frame)
    "Enable KKP mode when a terminal frame connects."
    (unless (display-graphic-p frame)
      (global-kkp-mode +1)))

  (add-hook 'after-make-frame-functions #'my/maybe-enable-kkp)
  (unless (display-graphic-p)
    (global-kkp-mode +1))

  ;; Restore traditional terminal key equivalences that KKP makes distinct
  (define-key input-decode-map (kbd "C-[") [escape])
  (define-key input-decode-map (kbd "C-m") [return])
  (define-key input-decode-map (kbd "C-i") [tab]))
  (define-key input-decode-map (kbd "C-j") (kbd "\n"))
(provide 'kkp-config)
;;;end kkp-config.el
