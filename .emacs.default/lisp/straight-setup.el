;; Reset variables related to Elpaca
(setq elpaca-installer-version nil)
(setq elpaca-directory nil)
(setq elpaca-builds-directory nil)
(setq elpaca-repos-directory nil)
(setq elpaca-order nil)

;; Remove Elpaca directories if they exist
(let ((elpaca-dir (expand-file-name "elpaca/" user-emacs-directory)))
  (when (file-exists-p elpaca-dir)
    (delete-directory elpaca-dir t)))

;; Remove elpaca from load-path
(setq load-path (delete (expand-file-name "elpaca/" elpaca-builds-directory) load-path))
(setq load-path (delete (expand-file-name "elpaca/" elpaca-repos-directory) load-path))

;; Unbind any elpaca-related functions if defined
(dolist (fn '(elpaca elpaca-use-package elpaca-process-queues elpaca-generate-autoloads elpaca-autoloads))
  (when (fboundp fn)
    (fmakunbound fn)))

;; Unload elpaca features if loaded
(dolist (feature '(elpaca elpaca-autoloads elpaca-use-package))
  (when (featurep feature)
    (unload-feature feature t)))

;; Remove any hooks related to Elpaca
(remove-hook 'after-init-hook #'elpaca-process-queues)




(setq straight-use-package-by-default t)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(provide 'straight-setup)

