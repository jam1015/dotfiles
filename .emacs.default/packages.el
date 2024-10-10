(load-relative "elpaca_setup.el")
;;(elpaca (evil :host github :repo "emacs-evil/evil" ) )


;;(elpaca use-package)
(use-package god-mode :ensure t)

(use-package evil :ensure t :demand t
  :init
  (setq evil-default-state 'normal)
  :custom
  (display-line-numbers-type 'relative)
   (savehist-additional-variables '(evil-ex-history))
   (savehist-mode 1)

  :config
  (evil-mode 1)
  (global-display-line-numbers-mode t)
  )
;;
;;
;;(use-package evil-god-state)
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

(use-package nord-theme :ensure (:host github :repo "nordtheme/emacs") :demand t)
