(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package straight
  :custom
  (straight-use-package-by-default t))

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(straight-use-package 'use-package)
(straight-use-package 'god-mode)

(use-package evil
  :init
  (setq evil-default-state 'normal)
  :config
  (evil-mode 1))


(use-package evil-god-toggle
  :straight (:local-repo "evil-god-toggle")
  :config

  (global-set-key (kbd "C-;") (lambda () (interactive) (god-toggle t)))
  (global-set-key (kbd "C-,") (lambda () (interactive) (god-toggle nil)))

  ;;(global-set-key (kbd "C-z") 'evil-emacs-state)
  (setq insert-to-god-cursor-strategy "same")
  (setq persist_visual t)
  (setq persist_visual_to_evil t)
  (setq persist_visual_to_god t)

  (define-key evil-god-state-map (kbd "C-z") 'evil-emacs-state)  ;; Bind C-z to evil-emacs-state
  ;; also works
  ;;(global-set-key (kbd "C-z") 'save-buffer)
  ;; for some reasos these bindings don't work
  ;;(evil-define-key 'god evil-god-state-map (kbd "C-z") nil)
  ;;(evil-define-key 'god evil-god-state-map (kbd "C-z") 'evil-emacs-state)

  (evil-define-key 'god global-map "C-;" (lambda () (interactive) (god-toggle t)))
  (evil-define-key 'god global-map "C-," (lambda () (interactive) (god-toggle nil)))
  (evil-define-key 'god global-map [escape] (lambda () (interactive) (evil-stop-execute-in-god-state nil)))
  (setq evil-god-state-cursor '(box "Red"))
  (setq evil-insert-state-cursor '(bar "Red"))
  (setq evil-visual-state-cursor '(hollow "Red"))
  (setq evil-normal-state-cursor '(box "White")))

