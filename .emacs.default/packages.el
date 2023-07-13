(setq straight-repository-branch "develop")
(defvar bootstrap-version)
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

(setq straight-use-package-by-default t)
(straight-use-package 'use-package)
(use-package straight
  :custom
  (straight-use-package-by-default t))
(setq use-package-always-ensure t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; tree sitter
(use-package tree-sitter
  :config
  ;;(add-hook 'markdown-mode-hook #'tree-sitter-hl-mode)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )
(use-package tree-sitter-langs)
(require 'tree-sitter)
(require 'tree-sitter-langs)



(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))



(use-package ace-window
  :bind
  (("M-o" . ace-window))
  )

;; Enable ace-window and assign a keybinding
;;(global-set-key (kbd "M-o") 'ace-window)

;; Install Zenburn theme
(straight-use-package 'zenburn-theme)
;; Load Zenburn theme on startup
(load-theme 'zenburn t)


(straight-use-package
 '(sly :type git :host github :repo "joaotavora/sly" :branch "master"))

(require 'sly-autoloads)

(setq sly-lisp-implementations
      '(
	(sbcl ("/usr/bin/sbcl") :coding-system utf-8-unix) (clisp ("/usr/bin/clisp" "-K full") :coding-system utf-8-unix)))

(eval-after-load 'sly
  `(define-key sly-prefix-map (kbd "M-h") 'sly-documentation-lookup))

(straight-use-package 'god-mode)
(setq god-exempt-major-modes nil)
(setq god-exempt-predicates nil)
(require 'god-mode)
;;(god-mode)

(use-package undo-tree)

( use-package evil
  :ensure t
  :init
  (setq evil-disable-insert-state-bindings t)
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (global-undo-tree-mode)
  (setq evil-undo-system 'undo-tree)
  (add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
  )

(straight-use-package 'evil-leader)

(global-evil-leader-mode)

(setq evil-want-keybinding nil)
(require 'evil-leader)

(require 'evil)

(unless (and (featurep 'evil) evil-mode)
  (require 'evil)
  (evil-mode 1)
  (setq evil-default-state 'normal)
  ;;(evil-emacs-state)
  )


(straight-use-package 'evil-collection)
(use-package evil-collection
  :straight t
  :after evil
  :ensure t
  :config
  (evil-collection-init)
  )




;; Define a function to toggle evil/emacs state and god-mode
(defun my-toggle-evil-emacs-and-god-mode ()
  "Toggle between evil and emacs state, then toggle god-mode."
  (interactive)
  (cond
   
   ( (eq evil-state 'insert) 
     (god-mode-all))
   ;; (insert, on) -> (emacs, off)
   ;;((and (eq evil-state 'insert) (bound-and-true-p god-local-mode))
    ;;(evil-insert-state)
    ;;(god-mode-all)
    ;;)
   ;;;; (insert, off) -> (emacs, off)
   ;;((and (eq evil-state 'insert) (not (bound-and-true-p god-local-mode)))
    ;;(evil-insert-state)
    ;;)
   ;; (normal+ , on) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs))) (bound-and-true-p god-local-mode))
    (evil-insert-state)
    )
   ;; (normal+ , off) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs))) (not (bound-and-true-p god-local-mode)))
    (evil-insert-state)
    (god-mode-all))
   (t (god-mode-all))

   )
  )

;; Configure keybindings

(define-key global-map (kbd "C-,") 'my-toggle-evil-emacs-and-god-mode)

(define-key god-local-mode-map (kbd ".") #'repeat)

(defun disable-god-mode-in-evil-normal-state ()
  "Disable `god-mode' when entering `evil-normal-state'."
  (when (and (bound-and-true-p god-global-mode)
	     (eq evil-state 'normal))
    (god-mode-all)))

(add-hook 'evil-normal-state-entry-hook 'disable-god-mode-in-evil-normal-state)



(evil-set-initial-state 'Info-mode 'insert)


(defun my-info-mode-settings ()
  (god-local-mode 1))

(add-hook 'Info-mode-hook 'my-info-mode-settings)



(require 'evil)


(defun update-cursor-according-to-mode ()
  (cond
   ((and (eq evil-state 'insert) god-local-mode)
    (setq cursor-type 'box)
    (set-cursor-color "red"))
   ((or (eq evil-state 'insert) god-local-mode)
    (setq cursor-type 'bar)
    (set-cursor-color "red"))
   (t
    (setq cursor-type 'box)
    (set-cursor-color "black"))))

(add-hook 'post-command-hook 'update-cursor-according-to-mode)
(add-hook 'buffer-list-update-hook 'update-cursor-according-to-mode)

(custom-set-faces
 '(god-mode-lighter ((t (:inherit error)))))
