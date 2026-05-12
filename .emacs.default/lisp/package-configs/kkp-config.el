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
    (global-kkp-mode +1)
    ;; KKP decodes C-[ (keycode 91 + ctrl) to char 27, not [escape].
    ;; Map char 27 → [escape] here (after input-decode-map, so kkp's \033[?
    ;; handler registration is unaffected). Lambda guard prevents GUI impact.
    (define-key key-translation-map (kbd "C-[")
      (lambda (_prompt) (if (display-graphic-p) nil [escape])))))

(provide 'kkp-config)
;;;end kkp-config.el
