;; Core Emacs Settings
(use-package emacs
  :ensure nil
  :demand t
  :init

   (set-frame-font "Lilex Nerd Font Mono-10" t t)
  :custom
  ;; Startup and UI
  (inhibit-startup-screen t)
  (visible-bell t)
  (cursor-in-non-selected-windows nil)
  
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
  ;; Disable cursor blinking
  (blink-cursor-mode 0)
  
  ;; Remember cursor positions across sessions
  (save-place-mode 1)

;; more common: redirect to a real but ignored file
(setq custom-file (expand-file-name "custom-dump.el" user-emacs-directory))

  )
(defun my/apply-theme (frame)
  (with-selected-frame frame
    (when (display-graphic-p frame)
      (load-theme 'doom-old-hope t))))
(add-hook 'after-make-frame-functions #'my/apply-theme)
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (when (display-graphic-p)
              (load-theme 'doom-old-hope t))))

;;  (add-hook 'elpaca-after-init-hook
;;            (lambda ()
;;              (load-theme 'anisochromatic t)
;;              (set-frame-font "InputMonoNerdFont-10" t t)))
;; Which-key Configuration (currently disabled)
;; Uncomment to enable helpful keybinding hints
;; (use-package which-key
;;   :ensure t
;;   :demand t
;;   :custom
;;   ;; Timing settings
;;   (which-key-idle-delay 0.2)
;;   (which-key-idle-secondary-delay 0.05)
;;   
;;   ;; Popup appearance
;;   (which-key-popup-type 'side-window)
;;   (which-key-side-window-location 'bottom)
;;   (which-key-side-window-max-height 0.25)
;;   
;;   ;; Sorting and display
;;   (which-key-sort-order 'which-key-prefix-then-key-order)
;;   (which-key-sort-uppercase-first nil)
;;   (which-key-separator " → ")
;;   (which-key-prefix-prefix "+ ")
;;   
;;   :config
;;   (which-key-mode 1))

(provide 'settings)
;;;end settings.el
