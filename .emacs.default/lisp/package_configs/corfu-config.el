(use-package corfu
  :ensure t
  :init
  ;; Enable Corfu globally
  (global-corfu-mode)

  :custom
  (corfu-count 25)
  (corfu-cycle t)                      ;; wrap at ends
  (corfu-auto t)                       ;; popup as you type
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)                ;; start completing after 1 char
  (corfu-preselect 'prompt)
  (corfu-quit-at-boundary 'separator)  ;; stay open on "/" boundary
  (corfu-quit-no-match 'separator)     ;; stay open even when no match

  :bind
  (:map corfu-map
        ("TAB"       . corfu-next)
        ("<tab>"     . corfu-next)
        ("S-TAB"     . corfu-previous)
        ("<backtab>" . corfu-previous)
         ("C-SPC" . corfu-insert   )
	)

  :config
  (corfu-history-mode)
  (corfu-popupinfo-mode)

 ;; Custom RET handling for Evil ex-commands
  (defun my/evil-ex-corfu-send-and-execute ()
    "In Evil ex minibuffer, accept Corfu completion and execute."
    (interactive)
    (if (and (minibufferp)
             (string-match-p "^:" (or (minibuffer-prompt) "")))
        (progn
          ;; Accept the completion
          (when (>= corfu--index 0)
            (corfu-insert))
          ;; Then execute the command
          (exit-minibuffer))
      ;; If not in Evil ex minibuffer, fall back to normal corfu-send
      (corfu-send)))

  ;; Apply the custom RET binding AFTER everything else
  (define-key corfu-map (kbd "RET") #'my/evil-ex-corfu-send-and-execute)
  (define-key corfu-map (kbd "<return>") #'my/evil-ex-corfu-send-and-execute)


;; ─── Debug Corfu popup ─────────────────────────────────────────────────
(advice-add 'corfu--show :before (lambda (&rest _) (message "⟫ Corfu popup SHOW")))
(advice-add 'corfu--hide :before (lambda (&rest _) (message "⟪ Corfu popup HIDE")))

;; In your config, after Corfu is set up:
(defun my/eshell-corfu-return ()
  "In Eshell, if Corfu popup is visible insert completion, then send input."  
  (interactive)
  (if (and (bound-and-true-p corfu-mode)
           (fboundp 'corfu--popup-visible-p)
           (corfu--popup-visible-p))
      (progn
        (corfu-insert)      ;; accept the Corfu candidate
        (eshell-send-input))
    (eshell-send-input))) ;; normal RET

(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key (kbd "RET")      #'my/eshell-corfu-return)
            (local-set-key (kbd "<return>") #'my/eshell-corfu-return)))

;; ─── Helper to inspect what RET is bound to ──────────────────────────────────

(defun my/debug-ret-key ()
  (interactive)
  (message "DEBUG: RET maps to %S"
           (key-binding (kbd "RET"))))

;; Bind C-c RET in corfu-popup and in all minibuffers
(define-key corfu-map  (kbd "C-c RET") #'my/debug-ret-key)
(add-hook 'minibuffer-setup-hook
          (lambda () (local-set-key (kbd "C-c RET") #'my/debug-ret-key)))


(defgroup my/corfu-strip nil
  "Strip trailing slash from real-directory completions in Corfu."
  :group 'corfu)

(defun my/corfu--strip-slash (s)
  "If S ends in “/” and is a real directory, drop the slash."
  (if (and (stringp s)
           (string-suffix-p "/" s)
           (file-directory-p s))
      (directory-file-name s)
    s))

(defun my/corfu--replace-advice (orig beg end str)
  "Advice around `corfu--replace' to drop trailing “/” on directories."
  (funcall orig beg end (my/corfu--strip-slash str)))

(defun my/corfu--preview-advice (&rest _)
  "Advice after `corfu--preview-current' to drop trailing “/” in the inline preview."
  (when (overlayp corfu--preview-ov)
    (let* ((ov   corfu--preview-ov)
           (disp (overlay-get ov 'display))
           (clean (and (stringp disp) (my/corfu--strip-slash disp))))
      (when clean
        (overlay-put ov 'display clean)))))

;;;###autoload
(define-minor-mode my/corfu-dir-strip-mode
  "Toggle stripping trailing slash for directory candidates in Corfu."
  :global t
  :group 'my/corfu-strip
  (if my/corfu-dir-strip-mode
      (progn
        ;; enable
        (advice-add 'corfu--replace         :around #'my/corfu--replace-advice)
        (advice-add 'corfu--preview-current :after  #'my/corfu--preview-advice))
    (progn
      ;; disable
      (advice-remove 'corfu--replace         #'my/corfu--replace-advice)
      (advice-remove 'corfu--preview-current #'my/corfu--preview-advice))))
;; Turn it on by default:
(my/corfu-dir-strip-mode 1)
)

(provide 'corfu-config)
;;;end corfu-config.el
