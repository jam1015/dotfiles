(load-file "~/.emacs.default/settings.el")
(load-file "~/.emacs.default/packages.el")
(load-file "~/.emacs.default/mappings.el")




;; Refresh package contents
;;(unless package-archive-contents
;;  (package-refresh-contents))
;;
;; (straight-use-package
;; '(sly :type git :host github :repo "joaotavora/sly" :branch "master"))
;;
;;(straight-use-package 'god-mode)
;;
;;;;(unless (package-installed-p 'slime)
;;;;  (package-install 'slime))
;;
;;(straight-use-package 'evil)
;;
;;
;;(straight-use-package 'evil-leader)
;;
;;(straight-use-package 'evil-collection)
;;
;; Load required packages
;;(setq evil-want-keybinding nil)
;;(require 'god-mode)
;;(require 'evil-leader)
;;(require 'evil)
;;(require 'evil-collection)
;;
;; Define a function to toggle evil/emacs state and god-mode
;;;;(defun my-toggle-evil-emacs-and-god-mode ()
;;;;  "Toggle between evil and emacs state, then toggle god-mode."
;;;;  (interactive)
;;;;  (cond
;;;;   ;; (emacs, on) -> (emacs, off)
;;;;   ((and (eq evil-state 'emacs)
;;;;         (bound-and-true-p god-local-mode))
;;;;    ;;(evil-normal-state)
;;;;    (god-mode-all))
;;;;   ;; (normal (or any evil state not including insert and emacs), off) -> (emacs, on)
;;;;   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs)))
;;;;         (not (bound-and-true-p god-local-mode)))
;;;;    (evil-emacs-state)
;;;;    (god-mode-all))
;;;;   ;; (insert, on) -> (emacs, off)
;;;;   ((and (eq evil-state 'insert)
;;;;         (bound-and-true-p god-local-mode))
;;;;    (god-mode-all)
;;;;	(evil-emacs-state))
;;;;   ;; (emacs, off) -> (emacs, on)
;;;;   ((and (eq evil-state 'emacs)
;;;;         (not (bound-and-true-p god-local-mode)))
;;;;    (god-mode-all))
;;;;   ;; (normal (or any evil state not including insert and emacs), on) -> (normal, off)
;;;;   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs)))
;;;;         (bound-and-true-p god-local-mode))
;;;;    (god-mode-all))
;;;;   ;; (insert, off) -> (emacs, on)
;;;;   ((and (eq evil-state 'insert)
;;;;         (not (bound-and-true-p god-local-mode)))
;;;;    (evil-emacs-state)
;;;;    (god-mode-all)
;;;;	)
;;;;
;;;;   (t (god-mode-all)
;;;;
;;;;	)
;;;;
;;;;   ))
;;;;
;;;;;; Configure keybindings
;;;;(global-evil-leader-mode)
;;;;(evil-mode 1)
;;;;
;;;;(setq god-exempt-major-modes nil)
;;;;(setq god-exempt-predicates nil)
;;;;(define-key global-map (kbd "C-,") 'my-toggle-evil-emacs-and-god-mode)
;;;;
;;;;;;(global-set-key (kbd "C-,") #'god-mode-all)
;;;;    ;; Enable evil-collection
;;;;    (evil-collection-init)
;;;;    ;; Initialize SLIME
;;;;    ;;(global-set-key (kbd "<escape>") #'god-mode-all)
;;;;    ;;(global-set-key (kbd "C-,") #'god-mode-all)
;;;;    (define-key god-local-mode-map (kbd ".") #'repeat)
;;;;    ;;(require 'slime)
;;;;    ;;(setq inferior-lisp-program "/usr/bin/sbcl")
;;;;    ;;(slime-setup '(slime-fancy))
;;;;    
;;;;    
;;;;    (require 'sly)
;;;;;;(require 'slime)
;;;;
;;;;
;;;;
;;;;		;; clisp doesn't work "-K full"
;;;;        ;;(sbcl ("/usr/bin/sbcl") :coding-system utf-8-unix) 
;;;;;;(setq sly-lisp-implementations
;;;;;;      '(
;;;;;;		(clisp ("/usr/bin/clisp" "-K full" ) )
;;;;;;		)
;;;;;;	  )
;;;;(setq sly-lisp-implementations
;;;;      '(
;;;;        (sbcl ("/usr/local/bin/sbcl") :coding-system utf-8-unix) (clisp ("/usr/local/bin/clisp" "-K full") :coding-system utf-8-unix)))
;;;;;;(eval-after-load 'sly
;;;;;;  `(define-key sly-prefix-map (kbd "M-h") 'sly-documentation-lookup))
;;;;
;;;;    (require 'evil)
;;;;    
;;;;    (require 'evil)
;;;;    
;;;;    ;; Define a custom operator
;;;;    (evil-define-operator my-evil-change-and-emacs-state (beg end type register yank-handler)
;;;;      "Change text from BEG to END with TYPE, REGISTER and YANK-HANDLER."
;;;;      :move-point nil
;;;;      (interactive "<R><x><y>")
;;;;      (evil-change beg end type register yank-handler)
;;;;      (evil-emacs-state))
;;;;    
;;;;    ;; Define other custom commands
;;;;    (defun my-evil-append-line-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-append-line nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    (defun my-evil-append-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-append nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    (defun my-evil-insert-line-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-insert-line nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    (defun my-evil-insert-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-insert nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    (defun my-evil-open-below-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-open-below nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    (defun my-evil-open-above-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-open-above nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    (defun my-evil-change-line-and-emacs-state ()
;;;;      (interactive)
;;;;      (evil-change-line nil)
;;;;      (evil-emacs-state))
;;;;    
;;;;    ;; Remap keys to new functions
;;;;    (define-key evil-normal-state-map (kbd "A") 'my-evil-append-line-and-emacs-state)
;;;;    (define-key evil-normal-state-map (kbd "a") 'my-evil-append-and-emacs-state)
;;;;    (define-key evil-normal-state-map (kbd "I") 'my-evil-insert-line-and-emacs-state)
;;;;    (define-key evil-normal-state-map (kbd "i") 'my-evil-insert-and-emacs-state)
;;;;    (define-key evil-normal-state-map (kbd "o") 'my-evil-open-below-and-emacs-state)
;;;;    (define-key evil-normal-state-map (kbd "O") 'my-evil-open-above-and-emacs-state)
;;;;    (define-key evil-operator-state-map (kbd "C") 'my-evil-change-and-emacs-state)
;;;;    
;;;;    ;; Bind escape to switch back to normal state in emacs state
;;;;    (defvar my-evil-normal-state-override-map (make-sparse-keymap)
;;;;      "Keymap for overriding `evil-emacs-state-map' keys.")
;;;;    
;;;;    (define-key my-evil-normal-state-override-map [escape] 'evil-normal-state)
;;;;    (define-key my-evil-normal-state-override-map (kbd "C-[") 'evil-normal-state)
;;;;    
;;;;    (define-minor-mode my-evil-normal-state-override-mode
;;;;      "Minor mode for overriding `evil-emacs-state-map' keys."
;;;;      :keymap my-evil-normal-state-override-map)
;;;;    
;;;;    (defun my-god-mode-enabled-hook ()
;;;;      (my-evil-normal-state-override-mode -1))
;;;;    
;;;;    (defun my-god-mode-disabled-hook ()
;;;;      (my-evil-normal-state-override-mode 1))
;;;;    
;;;;    (add-hook 'god-mode-enabled-hook 'my-god-mode-enabled-hook)
;;;;    (add-hook 'god-mode-disabled-hook 'my-god-mode-disabled-hook)
;;;;
;;;;    ;; end escape hook
;;;;    
;;;;    
;;;;    
;;;;    (setq evil-emacs-state-cursor '("black" bar)) ; Set cursor to a red line in emacs state
;;;;    
;;;;    (defun my-enable-god-mode-cursor ()
;;;;      (setq cursor-type 'box)) ; Set cursor to a box in god mode
;;;;    
;;;;    (defun my-disable-god-mode-cursor ()
;;;;      (setq cursor-type '(bar . 1))) ; Set cursor to a line when not in god mode
;;;;    
;;;;    (add-hook 'god-mode-enabled-hook 'my-enable-god-mode-cursor)
;;;;    (add-hook 'god-mode-disabled-hook 'my-disable-god-mode-cursor)
;;;;    
;;;;
;;;;
;;;;
;;;;(defun toggle-evil-mode ()
;;;;  "Toggle evil-mode on and off."
;;;;  (interactive)
;;;;  (if (bound-and-true-p evil-mode)
;;;;      (evil-mode 0)
;;;;    (evil-mode 1)))
;;;;
;;;;(global-set-key (kbd "C-c t") 'toggle-evil-mode)
;;;;
;;;;    
;;;;(custom-set-variables
;;;; ;; custom-set-variables was added by Custom.
;;;; ;; If you edit it by hand, you could mess it up, so be careful.
;;;; ;; Your init file should contain only one such instance.
;;;; ;; If there is more than one, they won't work right.
;;;; '(package-selected-packages '(sly macrostep evil-leader evil-god-state evil-collection)))
;;;;    
;;;;(custom-set-faces
;;;; ;; custom-set-faces was added by Custom.
;;;; ;; If you edit it by hand, you could mess it up, so be careful.
;;;; ;; Your init file should contain only one such instance.
;;;; ;; If there is more than one, they won't work right.
;;;; )
;;;;
;;;;
