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
  (message "Writing pwd: %s" default-directory)  ;; DEBUG
  (eshell-config--ensure-whereami-dir)
  (with-temp-file eshell-config-whereami-file
    (insert (expand-file-name default-directory))))

(defun eshell-config-restore-pwd ()
  "Jump to the directory recorded in the most recent eshell-whereami file." 
  (let ((whereami-file (or (and (file-readable-p eshell-config-whereami-file)
                                eshell-config-whereami-file)
                           (eshell-config--find-most-recent-whereami))))
    (when (and whereami-file (file-readable-p whereami-file))
      (let ((saved (string-trim (with-temp-buffer
                                  (insert-file-contents whereami-file)
                                  (buffer-string)))))
        (when (and (not (string-empty-p saved))
                   (file-directory-p saved)
                   (not (string-equal (expand-file-name saved)
                                       (expand-file-name default-directory))))
          (condition-case err
              (progn
                (cd saved)
                (eshell/cd saved)
                (message "Restored eshell to: %s" saved))
            (error (message "eshell-config: Could not restore to %s: %s" 
                           saved (error-message-string err)))))))))

(defun eshell-config-define-aliases ()
  "Define common convenience aliases in the current Eshell buffer."
  (dolist (pair '(
		              ("ff" . "find-file $1")
                  ("vi" . "find-file $1")
                  ("ll" . "ls -la $*")
                  ("la" . "ls -a $*")))
    (eshell/alias (car pair) (cdr pair))))

;;(defun eshell/ff (&rest files)
;;  "In Eshell, open each FILE in the current Emacs frame."
;;  (dolist (f files)
;;    (find-file (expand-file-name f))))
;;(defalias 'eshell/vi 'eshell/ff)

(defvar eshell-config--initialized-buffers nil
  "List of eshell buffers that have been initialized.")

(defun eshell-config--cleanup-buffer-list ()
  "Remove current buffer from initialized list when killed."
  (setq eshell-config--initialized-buffers
        (delq (current-buffer) eshell-config--initialized-buffers)))

(defun eshell-config-initialize ()
  "Set up Eshell conveniences in the current buffer."
  (message "eshell-config-initialize called, buffer: %s" (current-buffer))
  (message "Already initialized buffers: %s" eshell-config--initialized-buffers)
  ;; Only restore if this buffer hasn't been initialized yet
  (unless (memq (current-buffer) eshell-config--initialized-buffers)
    (message "This is a new buffer, attempting restore...")
    (push (current-buffer) eshell-config--initialized-buffers)
    (eshell-config-restore-pwd)
    (add-hook 'kill-buffer-hook #'eshell-config--cleanup-buffer-list nil t)
    ;; Add this part for Evil insert mode
    (goto-char (point-max))
    (when (fboundp 'evil-insert)
      (evil-insert 1)))
  ;; Record dir after every command
  (add-hook 'eshell-post-command-hook #'eshell-config-write-pwd nil t)
  ;; Add aliases
  (eshell-config-define-aliases))


(add-hook 'eshell-mode-hook #'eshell-config-initialize)



(defun my/eshell-enter-insert-after-prompt ()
  "Always go to end of Eshell and enter insert mode after prompt."
  (when (eq major-mode 'eshell-mode)
    (goto-char (point-max))
    (when (fboundp 'evil-insert)
      (evil-insert 1))))

(add-hook 'eshell-after-prompt-hook #'my/eshell-enter-insert-after-prompt)



(defun my/setup-eshell-evil-window-keys ()
  "Setup C-w as window command prefix in eshell."
  ;; Create a prefix keymap for C-w
  (evil-define-key 'insert eshell-mode-map (kbd "C-w") nil)
  
  ;; Window navigation
  (evil-define-key 'insert eshell-mode-map (kbd "C-w h") #'evil-window-left)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w j") #'evil-window-down)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w k") #'evil-window-up)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w l") #'evil-window-right)
  
  ;; Window manipulation
  (evil-define-key 'insert eshell-mode-map (kbd "C-w v") #'evil-window-vsplit)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w s") #'evil-window-split)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w c") #'evil-window-delete)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w o") #'delete-other-windows)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w q") #'evil-quit)
  
  ;; Window movement
  (evil-define-key 'insert eshell-mode-map (kbd "C-w H") #'evil-window-move-far-left)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w J") #'evil-window-move-very-bottom)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w K") #'evil-window-move-very-top)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w L") #'evil-window-move-far-right)
  
  ;; Window resizing
  (evil-define-key 'insert eshell-mode-map (kbd "C-w =") #'balance-windows)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w +") #'evil-window-increase-height)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w -") #'evil-window-decrease-height)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w >") #'evil-window-increase-width)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w <") #'evil-window-decrease-width)
  
  ;; Rotation and exchange
  (evil-define-key 'insert eshell-mode-map (kbd "C-w r") #'evil-window-rotate-downwards)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w R") #'evil-window-rotate-upwards)
  (evil-define-key 'insert eshell-mode-map (kbd "C-w x") #'evil-window-exchange)
  
  ;; If you still want access to the original C-w (kill-region), map it to C-w C-w
  (evil-define-key 'insert eshell-mode-map (kbd "C-w C-w") #'kill-region))

;; Apply the setup to eshell buffers
(add-hook 'eshell-mode-hook #'my/setup-eshell-evil-window-keys)






(provide 'eshell-config)
;;; eshell-config.el ends here

;;;end eshell-config.el
