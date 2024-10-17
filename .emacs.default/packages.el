(load-relative "elpaca_setup.el")
;;(elpaca (evil :host github :repo "emacs-evil/evil" ))

;;(elpaca use-package)
(use-package god-mode
  :ensure t
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (define-key god-local-mode-map (kbd ".") #'repeat))

(use-package undo-tree
  :ensure t
  :demand t
  :init
  (global-undo-tree-mode 1))

(use-package evil
  :ensure t
  :after undo-tree
  :init
  (setq evil-default-state 'normal)
  :custom
  (evil-undo-system 'undo-tree)
  (display-line-numbers-type 'relative)
  :config
  (evil-mode 1)
  (global-display-line-numbers-mode t)
  ;; Initialize savehist-additional-variables if it's void
  (unless (boundp 'savehist-additional-variables)
    (setq savehist-additional-variables nil))
  ;; Append 'evil-ex-history to savehist-additional-variables
  (add-to-list 'savehist-additional-variables 'evil-ex-history)
  ;; Turn on savehist-mode
  (savehist-mode 1)
  (evil-define-command evil-quit (&optional force)
    "Close the current window, current frame, current tab, Emacs.
If the current frame belongs to some client the client connection
is closed."
    :repeat nil
    (interactive "<!>")
    (condition-case nil
        (delete-window)
      (error
       (if (and (bound-and-true-p server-buffer-clients)
                (fboundp 'server-edit)
                (fboundp 'server-buffer-done))
           (if force
               (server-buffer-done (current-buffer))
             (server-edit))
         (condition-case nil
             (delete-frame)
           (error
            (condition-case nil
                (tab-bar-close-tab)
              (error
               (if force
                   (kill-emacs)
                 (save-buffers-kill-emacs)))))))))))

(use-package evil-god-toggle
  :ensure (:repo "~/evil-god-toggle")
  :config
  (global-set-key (kbd "C-;") (lambda () (interactive) (god-toggle t)))
  (global-set-key (kbd "C-,") (lambda () (interactive) (god-toggle nil)))
  (setq god_entry_strategy "default")
  (setq persist_visual t)
  (setq persist_visual_to_evil t)
  (setq persist_visual_to_god t)
  (evil-define-key 'god global-map "C-;" (lambda () (interactive) (god-toggle t)))
  (evil-define-key 'god global-map "C-," (lambda () (interactive) (god-toggle nil)))
  (evil-define-key 'god global-map [escape] (lambda () (interactive) (evil-stop-execute-in-god-state nil)))
  (setq evil-god-state-cursor '(box "Red"))
  (setq evil-insert-state-cursor '(bar "Red"))
  (setq evil-visual-state-cursor '(hollow "Red"))
  (setq evil-normal-state-cursor '(box "White")))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))  ; Enable system clipboard support for * and + registers

(use-package nord-theme
  :ensure (:host github :repo "nordtheme/emacs")
  :demand t)
