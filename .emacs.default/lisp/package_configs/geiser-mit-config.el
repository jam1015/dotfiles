(use-package geiser-mit
 :after corfu
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

;; 2 Bind SPC in Evil’s insert state for Geiser & Scheme
(dolist (map '(geiser-mode-map
               geiser-repl-mode-map
               scheme-mode-map))
  (when (boundp map)
    (evil-define-key 'insert
      ;; must unwrap the symbol to the actual keymap variable
      (symbol-value map)
      (kbd "SPC") #'my/geiser-space-insert)))
  )
(provide 'geiser-mit-config)
