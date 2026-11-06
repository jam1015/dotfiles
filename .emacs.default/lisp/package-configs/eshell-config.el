;;; eshell-config.el --- Eshell configuration -*- lexical-binding: t; -*-
;;
;; Personal Eshell setup.  Highlights:
;;
;; * A custom prompt that shows host, abbreviated `pwd', and (when
;;   available via Magit) the current git branch.
;; * Persistence of the last visited directory to
;;   `eshell-config-whereami-file' so a fresh Eshell buffer resumes
;;   where the previous one left off.
;; * A small set of convenience aliases (`ff'/`vi' to open files in
;;   Emacs, `ll'/`la' for common `ls' invocations).
;; * Evil-aware RET handling that cooperates with `eat-eshell-mode'
;;   so TUIs running under Eshell receive their own keystrokes.
;; * `C-w'-prefixed window-management bindings in insert state,
;;   mirroring the normal-state evil window map.

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

  (defun eshell-config--git-branch ()
    "Return the current git branch via Magit, or nil if unavailable."
    (when (fboundp 'magit-get-current-branch)
      (magit-get-current-branch)))

  (defun eshell-config-prompt ()
    "Build the Eshell prompt string.
Shows `host:pwd', optionally followed by the current git branch,
then a magenta `> ' separator."
    (let ((branch (eshell-config--git-branch)))
      (concat (system-name) ":"
              (abbreviate-file-name (eshell/pwd))
              (when branch (format " ⎇ %s" branch))
              " > ")))

  (setq eshell-prompt-function #'eshell-config-prompt
        eshell-prompt-regexp "^[^#$\n]* [>#] "
        eshell-highlight-prompt t)

  (defun eshell-config--ensure-whereami-dir ()
    "Create the parent directory of `eshell-config-whereami-file' if needed."
    (let ((dir (file-name-directory eshell-config-whereami-file)))
      (unless (file-directory-p dir)
        (make-directory dir t))))

  (defun eshell-config-write-pwd ()
    "Persist the current `default-directory' to `eshell-config-whereami-file'.
Run from `eshell-post-command-hook' so the latest directory is
always on disk for the next Eshell session to pick up."
    (eshell-config--ensure-whereami-dir)
    (with-temp-file eshell-config-whereami-file
      (insert (expand-file-name default-directory))))

  (defun eshell-config-restore-pwd ()
    "Change to the directory previously saved in `eshell-config-whereami-file'.
Silently does nothing if the file is missing, empty, the path is
not a directory, or it matches the current `default-directory'.
Errors from `cd' are caught and reported via `message'."
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
    "Drop the current buffer from `eshell-config--initialized-buffers'.
Installed on `kill-buffer-hook' so the init guard doesn't retain
dead buffers forever."
    (setq eshell-config--initialized-buffers
          (delq (current-buffer) eshell-config--initialized-buffers)))

  (defun eshell-config--find-files (args)
    "Open each file in ARGS via `find-file'.
ARGS comes from Eshell's `$*' expansion, so it may be nested;
flatten it first.  With no arguments, prompt interactively."
    (let ((files (flatten-tree args)))
      (if (null files)
          (call-interactively #'find-file)
        (dolist (file files)
          (find-file file)))
      nil))

  (defun eshell-config-define-aliases ()
    "Register the personal set of Eshell aliases for this buffer."
    (dolist (pair '(("ff" . "eshell-config--find-files $*")
                    ("vi" . "eshell-config--find-files $*")
                    ("ll" . "ls -la $*")
                    ("la" . "ls -a $*")))
      (eshell/alias (car pair) (cdr pair))))

  (defun eshell-config-initialize ()
    "One-shot plus per-buffer Eshell setup, run from `eshell-mode-hook'.
First-time work (restore saved pwd, register cleanup hook, jump
to the prompt) happens once per buffer, guarded by
`eshell-config--initialized-buffers'.  The post-command pwd
writer and alias definitions are (re)installed every call so
re-entering `eshell-mode' keeps them active."
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

  (defun my/eshell-send-input-or-eat ()
    "Submit eshell input, or forward RET to eat when a TUI is running.
When `eat-eshell-mode' has put the buffer under a visual subprocess,
RET must reach the child process as a terminal keystroke instead of
being interpreted as `eshell-send-input'."
    (interactive)
    (if (or (bound-and-true-p eat--eshell-semi-char-mode)
            (bound-and-true-p eat--eshell-char-mode))
        (call-interactively #'eat-self-input)
      (eshell-send-input)))

  (defun my/setup-eshell-evil-window-keys ()
    "Bind evil window-management keys (C-w …) in Eshell's insert state.
Also routes RET through `my/eshell-send-input-or-eat' and frees
plain `C-w' so it can act as a prefix instead of deleting a word."
    (evil-define-key 'insert eshell-mode-map (kbd "RET") #'my/eshell-send-input-or-eat)
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
