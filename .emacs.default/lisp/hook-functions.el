;;; hook-functions.el --- Named functions for use in hook registrations

(defun my/startup-open-eshell ()
  "Open eshell on startup if no files were passed as arguments."
  (when (not (cdr command-line-args))
    (eshell)))

(defun my/startup-reinit-evil-messages ()
  ;; *Messages* is created before packages load, so evil hooks fire before
  ;; evil-leader etc. register. Re-initialize after everything loads.
  (when (get-buffer "*Messages*")
    (with-current-buffer "*Messages*"
      (evil-local-mode -1)
      (evil-local-mode 1))))

(defun my/elpaca-after ()
  "Load the default theme after elpaca finishes initializing."
  (load-theme 'doom-tokyo-night t))

(provide 'hook-functions)
;;; end hook-functions.el
