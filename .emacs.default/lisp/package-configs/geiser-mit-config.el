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
  (my/mappings-geiser-mit))
(provide 'geiser-mit-config)
;;;end geiser-mit-config.el
