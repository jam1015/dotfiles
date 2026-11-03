;;; -*- lexical-binding: t; -*-
(message "Setting up package.el")

(require 'package)
(unless (assoc "melpa" package-archives)
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t))
;; GNU ELPA and NonGNU ELPA are included by default on Emacs 28+.
;; `package-initialize' is called automatically before init.el loads.

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Audit helper: list installed packages that ship .texi sources but have no
;; built .info files. Mirrors the previous elpaca version.
(defun +pkg/audit-missing-info ()
  "List installed packages that ship .texi sources but have no built .info files."
  (interactive)
  (let (missing)
    (dolist (desc (apply #'append (mapcar #'cdr package-alist)))
      (let ((dir (package-desc-dir desc))
            (name (symbol-name (package-desc-name desc))))
        (when (and (stringp dir) (file-directory-p dir))
          (let ((has-texi (directory-files-recursively dir "\\.texi\\'" nil nil t))
                (has-info (directory-files-recursively dir "\\.info\\'" nil nil t)))
            (when (and has-texi (not has-info))
              (push name missing))))))
    (setq missing (sort (delete-dups missing) #'string<))
    (with-current-buffer (get-buffer-create "*pkg-missing-info*")
      (erase-buffer)
      (if missing
          (progn
            (insert (format "%d package(s) ship .texi but have no built .info:\n\n"
                            (length missing)))
            (dolist (p missing) (insert "  " p "\n")))
        (insert "All installed packages with .texi sources have built .info files.\n"))
      (display-buffer (current-buffer)))
    missing))

(message "Finished setting up package.el")
(provide 'package-setup)
;;;end package-setup.el
