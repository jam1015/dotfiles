;;; hook-functions.el --- Named functions for use in hook registrations

(defun my/startup-open-eshell ()
  "Open eshell on startup if no files were passed as arguments."
  (when (not (cdr command-line-args))
    (eshell)))

(defun my/startup-reinit-evil-messages ()
  ;; *Messages* is created before packages load, so evil hooks fire before
  ;; evil-leader etc. register. Re-initialize after everything loads.
  (when (get-buffer "*Messages*")
    (with-current-buffer "*Messages*"
      (evil-local-mode -1)
      (evil-local-mode 1))))

(defvar my/default-theme 'doom-tokyo-night)

(defvar my/default-font-family "InputMono Nerd Font")
(defvar my/default-font-height 100)

(defun my/apply-default-font (&rest _)
  "Re-assert the default face font. Useful after `load-theme', which
typically resets the default face."
  (when (find-font (font-spec :family my/default-font-family))
    (set-face-attribute 'default nil
                        :family my/default-font-family
                        :height my/default-font-height)))

(defun my/elpaca-after-init ()
  "Run after Elpaca has finished processing init queues.
Add additional one-shot startup work here as needed."
  (unless (memq my/default-theme custom-enabled-themes)
    (when (or (daemonp) (display-graphic-p) (display-color-p))
      (load-theme my/default-theme t)))
  (my/apply-default-font))

;; Re-apply on any future theme switch too.
(when (boundp 'enable-theme-functions)
  (add-hook 'enable-theme-functions #'my/apply-default-font))

(defun my/repl-unify-return-bindings ()
  "In any comint-derived REPL, bind RET to submit in both insert+normal
and C-<return> to newline. Detects the REPL's submit function by reading
the evil-collection binding that the `evil-collection-repl-submit-state'
flag installs, falling back to `comint-send-input'."
  (when (derived-mode-p 'comint-mode)
    (let* ((map (current-local-map))
           (insert-ret (lookup-key (evil-get-auxiliary-keymap map 'insert t)
                                   (kbd "RET")))
           (normal-ret (lookup-key (evil-get-auxiliary-keymap map 'normal t)
                                   (kbd "RET")))
           (submit-fn (cond
                       ((and (functionp insert-ret)
                             (not (eq insert-ret 'newline))
                             (not (eq insert-ret 'evil-ret)))
                        insert-ret)
                       ((and (functionp normal-ret)
                             (not (eq normal-ret 'newline))
                             (not (eq normal-ret 'evil-ret)))
                        normal-ret)
                       (t #'comint-send-input))))
      (evil-define-key '(insert normal) map
        (kbd "RET")        submit-fn
        (kbd "<return>")   submit-fn
        (kbd "C-<return>") #'newline
        (kbd "C-RET")      #'newline))))

(defun my/kill-scratch-when-other-buffers (&rest _)
  "Kill *scratch* once any real (user-visible, non-scratch) buffer exists.
Self-removes from `window-buffer-change-functions' after firing."
  (when (and (get-buffer "*scratch*")
             (seq-some
              (lambda (b)
                (let ((n (buffer-name b)))
                  (and (not (string-prefix-p " " n))
                       (not (string= n "*scratch*")))))
              (buffer-list)))
    (kill-buffer "*scratch*")
    (remove-hook 'window-buffer-change-functions
                 #'my/kill-scratch-when-other-buffers)))

(provide 'hook-functions)
;;; end hook-functions.el
