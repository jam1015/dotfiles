(require 'cl-lib)  ;; For using 'cl-intersection'


;; Usage in Eshell:  ff foo.txt bar.org

(add-hook 'emacs-startup-hook (lambda ()
                                 (when (not (cdr command-line-args))
                                   (eshell))))

;; *Messages* is created before packages load, so evil-local-mode-hook fires
;; before evil-leader, unimpaired, etc. register themselves. Re-initialize
;; evil in the buffer after everything loads so all hooks run with a full load.
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (get-buffer "*Messages*")
              (with-current-buffer "*Messages*"
                (evil-local-mode -1)
                (evil-local-mode 1)))))

(add-hook 'server-after-make-frame-hook (lambda ()
                                 (when (not (cdr command-line-args))
                                   (eshell))))







(provide 'hooks)
;;;end hooks.el
