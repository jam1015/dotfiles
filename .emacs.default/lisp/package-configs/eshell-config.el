;;; eshell-config.el --- Eshell configuration -*- lexical-binding: t; -*-
(use-package eshell
  :ensure nil
  :init
  (defgroup eshell-config nil
    "Jordan's general Eshell configuration."
    :group 'eshell)

  (defcustom eshell-config-whereami-file
    (locate-user-emacs-file "eshell-whereami")
    "File that stores the last visited directory for Eshell."
    :type 'file
    :group 'eshell-config)

  :hook ((eshell-mode . eshell-config-initialize)
         (eshell-mode . my/setup-eshell-evil-window-keys))
  :config
  (defvar eshell-config--initialized-buffers nil
    "List of eshell buffers that have been initialized.")

  (defun eshell-config--ensure-whereami-dir ()
    (let ((dir (file-name-directory eshell-config-whereami-file)))
      (unless (file-directory-p dir)
        (make-directory dir t))))

  (defun eshell-config-write-pwd ()
    (eshell-config--ensure-whereami-dir)
    (with-temp-file eshell-config-whereami-file
      (insert (expand-file-name default-directory))))

  (defun eshell-config-restore-pwd ()
    (let ((whereami-file (and (file-readable-p eshell-config-whereami-file)
                              eshell-config-whereami-file)))
      (when (and whereami-file (file-readable-p whereami-file))
        (let ((saved (string-trim (with-temp-buffer
                                    (insert-file-contents whereami-file)
                                    (buffer-string)))))
          (when (and (not (string-empty-p saved))
                     (file-directory-p saved)
                     (not (string-equal (expand-file-name saved)
                                        (expand-file-name default-directory))))
            (condition-case err
                (progn (cd saved)
                       (message "Restored eshell to: %s" saved))
              (error (message "eshell-config: Could not restore to %s: %s"
                              saved (error-message-string err)))))))))

  (defun eshell-config--cleanup-buffer-list ()
    (setq eshell-config--initialized-buffers
          (delq (current-buffer) eshell-config--initialized-buffers)))

  (defun eshell-config-define-aliases ()
    (dolist (pair '(("ff" . "find-file $1")
                    ("vi" . "find-file $1")
                    ("ll" . "ls -la $*")
                    ("la" . "ls -a $*")))
      (eshell/alias (car pair) (cdr pair))))

  (defun eshell-config-initialize ()
    (unless (memq (current-buffer) eshell-config--initialized-buffers)
      (push (current-buffer) eshell-config--initialized-buffers)
      (eshell-config-restore-pwd)
      (add-hook 'kill-buffer-hook #'eshell-config--cleanup-buffer-list nil t)
      (goto-char (point-max)))
    (add-hook 'eshell-post-command-hook #'eshell-config-write-pwd nil t)
    (eshell-config-define-aliases))

  (defun my/eshell-enter-insert-after-prompt ()
    "Go to end of Eshell and enter insert mode after prompt."
    (when (eq major-mode 'eshell-mode)
      (goto-char (point-max))
      (when (fboundp 'evil-insert)
        (evil-insert 1))))

  (defun my/setup-eshell-evil-window-keys ()
    (evil-define-key 'insert eshell-mode-map (kbd "RET") #'eshell-send-input)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w") nil)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w h") #'evil-window-left)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w j") #'evil-window-down)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w k") #'evil-window-up)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w l") #'evil-window-right)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w v") #'evil-window-vsplit)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w s") #'evil-window-split)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w c") #'evil-window-delete)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w o") #'delete-other-windows)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w q") #'evil-quit)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w H") #'evil-window-move-far-left)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w J") #'evil-window-move-very-bottom)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w K") #'evil-window-move-very-top)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w L") #'evil-window-move-far-right)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w =") #'balance-windows)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w +") #'evil-window-increase-height)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w -") #'evil-window-decrease-height)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w >") #'evil-window-increase-width)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w <") #'evil-window-decrease-width)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w r") #'evil-window-rotate-downwards)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w R") #'evil-window-rotate-upwards)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w x") #'evil-window-exchange)
    (evil-define-key 'insert eshell-mode-map (kbd "C-w C-w") #'kill-region)))

(provide 'eshell-config)
;;; end eshell-config.el
