;; Core Emacs Settings
(use-package emacs
  :ensure nil
  :demand t
  :init
  (require 'hook-functions)

  :hook ((emacs-startup               . my/startup-open-eshell)
         (emacs-startup               . my/startup-reinit-evil-messages)
         (server-after-make-frame     . my/startup-open-eshell)
         (elpaca-after-init           . my/elpaca-after-init)
         (window-buffer-change-functions . my/kill-scratch-when-other-buffers)
         (after-change-major-mode-hook   . my/repl-unify-return-bindings))
  :bind ([remap list-buffers] . ibuffer)

  :custom
  ;; Startup and UI
  (inhibit-startup-screen t)
  (visible-bell t)
  (cursor-in-non-selected-windows nil)
	(tab-width 2)
  (xterm-mouse-mode t)
 
  ;; Scrolling behavior
  (scroll-margin 3)
  (scroll-conservatively 10000)

  (custom-unlispify-tag-names nil)
  (custom-unlispify-menu-entries nil)
  ;; Completion and interaction
  (tab-always-indent 'complete)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (text-mode-ispell-word-completion nil)

  ;; Compilation warnings
  (byte-compile-warnings t)

  :config
  (set-face-attribute 'default nil :family my/default-font-family :height my/default-font-height)
  ;(add-to-list 'default-frame-alist '(font . "CMU Typewriter Slashed-9"))
  ;; Disable cursor blinking
  (blink-cursor-mode 0)
	
  (setopt custom-unlispify-tag-names nil)
  (setopt custom-unlispify-menu-entries nil)


  (global-auto-revert-mode 1)
  ;; Optional: also revert non-file buffers like Dired
  (setq global-auto-revert-non-file-buffers t)
  ;; Remember cursor positions across sessions
  (save-place-mode 1)

;; more common: redirect to a real but ignored file
(setq custom-file (expand-file-name "custom-dump.el" user-emacs-directory))

  )


(provide 'emacs-config)
;;;end emacs-config.el
