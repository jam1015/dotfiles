(use-package kkp
  :ensure t
  :config
  (defun my/maybe-enable-kkp (frame)
    "Enable KKP mode and restore key equivalences for terminal frames."
    (unless (display-graphic-p frame)
      (with-selected-frame frame
        (global-kkp-mode +1)
        ;; Restore traditional terminal key equivalences
        (define-key input-decode-map (kbd "C-[") [escape])
        (define-key input-decode-map (kbd "C-m") [return])
        (define-key input-decode-map (kbd "C-i") [tab]))))

  (add-hook 'after-make-frame-functions #'my/maybe-enable-kkp)

  ;; Handle initial frame if Emacs started in a terminal
  (unless (display-graphic-p)
    (global-kkp-mode +1)
    (define-key input-decode-map (kbd "C-[") [escape])
    (define-key input-decode-map (kbd "C-m") [return])
    (define-key input-decode-map (kbd "C-i") [tab])))

(provide 'kkp-config)
;;;end kkp-config.el
