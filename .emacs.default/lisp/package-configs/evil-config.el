(use-package evil
  :after which-key
  :ensure (:wait t)
  ;;:after undo-tree
  :init
  (setq lazy-highlight-cleanup nil)
  (setq lazy-highlight-max-at-a-time nil)
  (setq evil-want-keybinding nil
	evil-want-integration t)
  (setq evil-default-state 'normal)

  :custom
  (evil-undo-system 'undo-tree)
  (display-line-numbers-type 'relative)
  :config

  (defun my/kill-this-buffer ()
    "Kill the current buffer without closing its window."
    (interactive)
    (let ((buf (current-buffer)))
      (switch-to-prev-buffer nil 'kill)
      (unless (eq buf (current-buffer))
        (kill-buffer buf))))

  (defun my/evil-write-and-bdelete ()
    "Save the current buffer, then kill it (like Vim’s :wbd)."
    (interactive)
    (save-buffer)
    (my/kill-this-buffer))

  

  (my/mappings-evil)

  (evil-mode 1)
  (global-display-line-numbers-mode t)
  ;; Initialize savehist-additional-variables if it's void
  (unless (boundp 'savehist-additional-variables)
    (setq savehist-additional-variables nil))
  ;; Append 'evil-ex-history to savehist-additional-variables
  (add-to-list 'savehist-additional-variables 'evil-ex-history)
  ;; Turn on savehist-mode
  (savehist-mode 1)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'eshell-mode 'normal)

  )
(provide 'evil-config)
;;;end evil-config.el
