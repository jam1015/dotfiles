(require 'cl-lib)  ;; For using 'cl-intersection'


;; Usage in Eshell:  ff foo.txt bar.org

(add-hook 'emacs-startup-hook (lambda ()
                                 (when (not (cdr command-line-args))
                                   (eshell))))

(add-hook 'server-after-make-frame-hook (lambda ()
                                 (when (not (cdr command-line-args))
                                   (eshell))))







(provide 'hooks)
;;;end hooks.el
