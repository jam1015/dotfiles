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

(defvar my/default-theme 'doom-tokyo-night)

(defun my/elpaca-after-init ()
  "Run after Elpaca has finished processing init queues.
Add additional one-shot startup work here as needed."
  (unless (memq my/default-theme custom-enabled-themes)
    (when (or (daemonp) (display-graphic-p) (display-color-p))
      (load-theme my/default-theme t))))

(provide 'hook-functions)
;;; end hook-functions.el
