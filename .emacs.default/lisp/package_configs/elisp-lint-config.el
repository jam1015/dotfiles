(use-package elisp-lint
  :ensure t
  :commands (elisp-lint-files-batch)

:config


(defun my/elisp-lint-current-file ()
  "Run elisp-lint on the current buffer's file."
  (interactive)
  (when buffer-file-name
    (elisp-lint-files-batch buffer-file-name)))


(define-key emacs-lisp-mode-map (kbd "C-c l") #'my/elisp-lint-current-file)
)

(provide 'elisp-lint-config)
