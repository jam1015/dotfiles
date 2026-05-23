(use-package geiser-mit
 :after ( corfu evil)
  :config
  (dolist (hook '(geiser-repl-mode-hook
                  geiser-mode-hook    ; for Scheme source buffers
                  scheme-mode-hook))  ; if you ever open plain scheme-mode
    (add-hook hook
              (lambda ()
                (setq-local corfu-auto        nil
                            corfu-auto-delay  0.25
                            corfu-auto-prefix 1))))
;; Bind in both REPL and source buffers
;; 1 Your space handler
(defun my/geiser-space-insert ()
  "If Corfu is showing, quit it; then insert a space unconditionally."
  (interactive)
  (when (and (bound-and-true-p corfu-mode)
             (fboundp #'corfu--popup-visible-p)
             (corfu--popup-visible-p))
    (corfu-quit))
  (self-insert-command 1))

  (my/mappings-geiser-mit))
(provide 'geiser-mit-config)
;;;end geiser-mit-config.el
