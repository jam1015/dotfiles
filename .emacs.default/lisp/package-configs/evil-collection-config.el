;;; -*- lexical-binding: t; -*-
(use-package evil-collection
  :ensure (:host github
           :repo "jam1015/evil-collection"
           :branch "sync_dev"
           :build (:sub elpaca--clone +elpaca/build-if-new)
           )
  :after evil which-key
  :custom
  (evil-collection-repl-submit-state 'insert)
  :config
  (setq evil-overriding-maps nil)
  (evil-collection-init)
  (my/mappings-unimpaired)
  ;; `evil-collection-unimpaired-mode' gets enabled in every buffer
  ;; via `global-evil-collection-unimpaired-mode', but that doesn't
  ;; trigger evil to refresh its active state-map cache, so bindings
  ;; like `[b' don't fire until a state round-trip.  Force the
  ;; refresh now and also on an idle timer in case :config fires
  ;; before all buffers have evil-local-mode on yet.
  (defun +my/evil-refresh-all-buffers ()
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (bound-and-true-p evil-local-mode)
          (evil-normalize-keymaps)))))
  (+my/evil-refresh-all-buffers)
  (run-with-idle-timer 0 nil #'+my/evil-refresh-all-buffers)
  ;; And for every subsequent buffer: whenever
  ;; `evil-collection-unimpaired-mode' is enabled in a buffer, refresh
  ;; evil's keymap cache so its bindings are immediately active.
  (add-hook 'evil-collection-unimpaired-mode-hook #'evil-normalize-keymaps))
(provide 'evil-collection-config)
;;;end evil-collection-config.el



;(use-package evil-collection
;  :after evil which-key
;  
;  :config
;  (setq evil-overriding-maps nil)
;  (evil-collection-init)
;  )
;(provide 'evil-collection-config)
;;;;end evil-collection-config.el
