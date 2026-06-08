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
  (xterm-mouse-mode t)
 
  ;; Scrolling behavior
  (scroll-margin 3)
  (scroll-conservatively 10000)

  ;; Completion and interaction
  (tab-always-indent 'complete)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (text-mode-ispell-word-completion nil)

  ;; Compilation warnings
  (byte-compile-warnings t)

  :config
  (set-face-attribute 'default nil :family "Lilex Nerd Font Mono" :height 100)
  ;; Disable cursor blinking
  (blink-cursor-mode 0)

  ;; Remember cursor positions across sessions
  (save-place-mode 1)

;; more common: redirect to a real but ignored file
(setq custom-file (expand-file-name "custom-dump.el" user-emacs-directory))

  )


(provide 'emacs-config)
;;;end emacs-config.el
