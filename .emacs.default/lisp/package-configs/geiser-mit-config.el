;; Override the codeberg-hosted menu recipe for the geiser transitive dep.
;; To revert, comment out this whole use-package form.
(use-package geiser
  :ensure
  (geiser
   :host gitlab :repo "emacs-geiser/geiser"
   :files ("elisp/*.el" "doc/dir" "doc/geiser.texi")))

(use-package geiser-mit
  ;; To revert to the codeberg MELPA recipe, comment the :ensure (...) lines
  ;; below and uncomment `:ensure t'.
  ;; :ensure t
  :ensure
  (geiser-mit
   :host gitlab :repo "emacs-geiser/mit"
   :files (:defaults "src" "src/*"))
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
