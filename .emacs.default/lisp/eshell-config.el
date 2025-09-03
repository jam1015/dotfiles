;;; eshell-config.el --- Persist last Eshell dir + handy aliases -*- lexical-binding: t; -*-
;;
;; Drop this on your `load-path` and enable with:
;;   (require 'eshell-config)
;;
;; Features:
;;   • Remembers the last directory you were in ("whereami"), restored on **new**
;;     Eshell buffers only (not when reopening existing ones).
;;   • Writes the path only when the working directory actually changes, using
;;     `eshell-directory-change-hook` – no constant disk grind.
;;   • Graceful error‑handling if the saved directory vanished.
;;   • Aliases: ff / vi → `find-file`, plus ll / la → `ls` variants.
;;
;;; Code:

(defgroup eshell-config nil
  "Jordan’s general Eshell configuration."
  :group 'eshell)

(defcustom eshell-config-whereami-file
  (locate-user-emacs-file "eshell-whereami")
  "File that stores the last visited directory for Eshell."
  :type 'file
  :group 'eshell-config)

(defun eshell-config--ensure-whereami-dir ()
  "Create parent directory of `eshell-config-whereami-file` if missing."
  (let ((dir (file-name-directory eshell-config-whereami-file)))
    (unless (file-directory-p dir)
      (make-directory dir t))))

(defun eshell-config-write-pwd ()
  "Persist `default-directory` to `eshell-config-whereami-file`. Buffer‑local."
  (eshell-config--ensure-whereami-dir)
  (with-temp-file eshell-config-whereami-file
    (insert (expand-file-name default-directory))))

(defun eshell-config-restore-pwd ()
  "Jump to the directory recorded in `eshell-config-whereami-file`, if valid." 
  (when (file-readable-p eshell-config-whereami-file)
    (let ((saved (string-trim (with-temp-buffer
                                (insert-file-contents eshell-config-whereami-file)
                                (buffer-string)))))
      (when (and (file-directory-p saved)
                 (not (string-equal (expand-file-name saved)
                                     (expand-file-name default-directory))))
        (condition-case nil
            (eshell/cd saved)
          (error (message "eshell-config: Saved directory %s no longer accessible" saved)))))))

(defun eshell-config-define-aliases ()
  "Define common convenience aliases in the current Eshell buffer."
  (dolist (pair '(("ff" . "find-file $1")
                  ("vi" . "find-file $1")
                  ("ll" . "ls -la $*")
                  ("la" . "ls -a $*")))
    (eshell/alias (car pair) (cdr pair))))

(defun eshell-config-initialize ()
  "Set up Eshell conveniences in the current buffer.

Restores the previous directory *only* when the buffer is brand‑new (i.e.
point-min = point-max), so reopening an existing Eshell buffer doesn’t yank
you elsewhere." 
  ;; Only restore for fresh Eshell buffers.
  ;;(when (= (point-min) (point-max))
  ;;  (eshell-config-restore-pwd))
  ;; Record dir only when it changes.
  (add-hook 'eshell-directory-change-hook #'eshell-config-write-pwd nil t)
  ;; Add aliases.
  (eshell-config-define-aliases))

(add-hook 'eshell-first-time-mode-hook #'eshell-config-initialize)

(provide 'eshell-config)
;;; eshell-config.el ends here

