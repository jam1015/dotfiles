;;Set up package.el to work with MELPA
(blink-cursor-mode 0)
(setq visible-bell 1)
(require 'package)

(setq straight-use-package-by-default t)
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

(straight-use-package 'ace-window)

;; Enable ace-window and assign a keybinding
(global-set-key (kbd "M-o") 'ace-window)

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



(straight-use-package 'evil)

( use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
)

(straight-use-package 'evil-leader)

(global-evil-leader-mode)

(setq evil-want-keybinding nil)
(require 'evil-leader)

(require 'evil
	 )

(unless (and (featurep 'evil) evil-mode)
  (require 'evil)
  (evil-mode 1)
(setq evil-default-state 'emacs)
  (evil-emacs-state))


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
   ;; (emacs, on) -> (emacs, off)
   ((and (eq evil-state 'emacs)
         (bound-and-true-p god-local-mode))
    ;;(evil-normal-state)
    (god-mode-all))
   ;; (normal (or any evil state not including insert and emacs), off) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs)))
         (not (bound-and-true-p god-local-mode)))
    (evil-emacs-state)
    (god-mode-all))
   ;; (insert, on) -> (emacs, off)
   ((and (eq evil-state 'insert)
         (bound-and-true-p god-local-mode))
    (god-mode-all)
	(evil-emacs-state))
   ;; (emacs, off) -> (emacs, on)
   ((and (eq evil-state 'emacs)
         (not (bound-and-true-p god-local-mode)))
    (god-mode-all))
   ;; (normal (or any evil state not including insert and emacs), on) -> (normal, off)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs)))
         (bound-and-true-p god-local-mode))
    (god-mode-all))
   ;; (insert, off) -> (emacs, on)
   ((and (eq evil-state 'insert)
         (not (bound-and-true-p god-local-mode)))
    (evil-emacs-state)
    (god-mode-all)
	)

   (t (god-mode-all)

	)

   ))

;; Configure keybindings

(define-key global-map (kbd "C-,") 'my-toggle-evil-emacs-and-god-mode)

    (define-key god-local-mode-map (kbd ".") #'repeat)



    

    (require 'evil)
(with-eval-after-load 'evil
  (setq evil-motion-state-modes nil))

 
    ;; Define a custom operator
    (evil-define-operator my-evil-change-and-emacs-state (beg end type register yank-handler)
      "Change text from BEG to END with TYPE, REGISTER and YANK-HANDLER."
      :move-point nil
      (interactive "<R><x><y>")
      (evil-change beg end type register yank-handler)
      (evil-emacs-state))
    ;; Define other custom commands
    (defun my-evil-append-line-and-emacs-state ()
      (interactive)
      (evil-append-line nil)
      (evil-emacs-state))
    
    (defun my-evil-append-and-emacs-state ()
      (interactive)
      (evil-append nil)
      (evil-emacs-state))
    
    (defun my-evil-insert-line-and-emacs-state ()
      (interactive)
      (evil-insert-line nil)
      (evil-emacs-state))
    
    (defun my-evil-insert-and-emacs-state ()
      (interactive)
      (evil-insert nil)
      (evil-emacs-state))
    
    (defun my-evil-open-below-and-emacs-state ()
      (interactive)
      (evil-open-below nil)
      (evil-emacs-state))
    
    (defun my-evil-open-above-and-emacs-state ()
      (interactive)
      (evil-open-above nil)
      (evil-emacs-state))
    
    (defun my-evil-change-line-and-emacs-state ()
      (interactive)
      (evil-change-line nil)
      (evil-emacs-state))
    
    ;; Remap keys to new functions
    (define-key evil-normal-state-map (kbd "A") 'my-evil-append-line-and-emacs-state)
    (define-key evil-normal-state-map (kbd "a") 'my-evil-append-and-emacs-state)
    (define-key evil-normal-state-map (kbd "I") 'my-evil-insert-line-and-emacs-state)
    (define-key evil-normal-state-map (kbd "i") 'my-evil-insert-and-emacs-state)
    (define-key evil-normal-state-map (kbd "o") 'my-evil-open-below-and-emacs-state)
    (define-key evil-normal-state-map (kbd "O") 'my-evil-open-above-and-emacs-state)
    (define-key evil-operator-state-map (kbd "C") 'my-evil-change-and-emacs-state)
    

(defvar my-override-keymap (make-sparse-keymap)
  "Keymap for `my-override-mode'.")

(define-key my-override-keymap (kbd "C-[") 'evil-normal-state)
(define-key my-override-keymap [escape] 'evil-normal-state)
(define-key evil-emacs-state-map (kbd "C-[") 'evil-normal-state)

(define-minor-mode my-override-mode
  "Minor mode for overriding key bindings."
  :global t
  :init-value t
  :keymap my-override-keymap)
(my-override-mode)


    (defun my-god-mode-enabled-hook()
  (my-override-mode -1)   ; disable override mode
  (define-key my-override-keymap (kbd "C-[") nil)  ; remove C-[ binding in override keymap
  (define-key evil-emacs-state-map (kbd "C-[") nil))  ; remove C-[ binding in emacs state

(defun my-god-mode-disabled-hook ()
  (my-override-mode 1)    ; enable override mode
  (define-key my-override-keymap (kbd "C-[") 'evil-normal-state)   ; restore C-[ binding in override keymap
  (define-key evil-emacs-state-map (kbd "C-[") 'evil-normal-state))   ; restore C-[ binding in emacs state

    
    (add-hook 'god-mode-enabled-hook 'my-god-mode-enabled-hook)
    (add-hook 'god-mode-disabled-hook 'my-god-mode-disabled-hook)

    
 (setq evil-emacs-state-cursor '("red" bar)) ; 
(setq evil-insert-state-cursor '("red" bar))    ; Insert mode
(setq evil-normal-state-cursor '("black" box))    ; Normal mode
(setq evil-visual-state-cursor '("black" box))    ; Visual mode
(setq evil-motion-state-cursor '("black" box))    ; Motion mode
(setq evil-replace-state-cursor '("black" box))   ; Replace mode
(setq evil-operator-state-cursor '("black" box))  ; Operator-pending mode


(defun my-god-mode-cursor-change ()
  "Changes the cursor to a box when entering god-mode."
  (setq cursor-type 'box))

(defun my-god-mode-cursor-restore ()
  "Restores the cursor based on the current evil state when leaving god-mode."
  (cond
   ((eq evil-state 'emacs) (setq cursor-type 'bar))
   ((eq evil-state 'insert) (setq cursor-type 'bar))
   ((eq evil-state 'normal) (setq cursor-type 'box))
   ((eq evil-state 'visual) (setq cursor-type 'box))
   ((eq evil-state 'motion) (setq cursor-type 'box))
   ((eq evil-state 'replace) (setq cursor-type 'box))
   ((eq evil-state 'operator) (setq cursor-type 'box))))

(add-hook 'god-mode-enabled-hook 'my-god-mode-cursor-change)
(add-hook 'god-mode-disabled-hook 'my-god-mode-cursor-restore)



(defun toggle-evil-mode ()
  "Toggle evil-mode on and off."
  (interactive)
  (if (bound-and-true-p evil-mode)
      (evil-mode 0)
    (evil-mode 1)))

(global-set-key (kbd "C-c t") 'toggle-evil-mode)

(set-frame-font "Input Mono-6.5" t t)



