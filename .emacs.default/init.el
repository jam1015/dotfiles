;Set up package.el to work with MELPA
(setq inhibit-startup-screen t)
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

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'markdown-mode-hook #'tree-sitter-hl-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)


(straight-use-package 'markdown-mode)
(setq auto-mode-alist
      (append
       '(("\\.md\\'" . markdown-mode))
       auto-mode-alist))

(defun reload-config ()
  "Reloads the Emacs configuration file."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

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



(straight-use-package 'undo-tree)
(straight-use-package 'evil)

( use-package evil
  :ensure t
  :init
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
;;  (evil-mode 1)
  (setq evil-default-state 'emacs)
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
   ;; (emacs, off) -> (emacs, on) and vice versa
   ( (eq evil-state 'emacs) 
    (god-mode-all))
   ;; (insert, on) -> (emacs, off)
   ((and (eq evil-state 'insert) (bound-and-true-p god-local-mode))
    (evil-emacs-state)
    (god-mode-all)
    )
   ;; (insert, off) -> (emacs, off)
   ((and (eq evil-state 'insert) (not (bound-and-true-p god-local-mode)))
    (evil-emacs-state)
    )
   ;; (normal+ , on) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs))) (bound-and-true-p god-local-mode))
    (evil-emacs-state)
    )
   ;; (normal+ , off) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs))) (not (bound-and-true-p god-local-mode)))
    (evil-emacs-state)
    (god-mode-all))
   (t)

   )
  )

;; Configure keybindings

(define-key global-map (kbd "C-,") 'my-toggle-evil-emacs-and-god-mode)

(define-key god-local-mode-map (kbd ".") #'repeat)





(require 'evil)
(with-eval-after-load 'evil
  (setq evil-motion-state-modes nil))
(evil-define-command my-evil-insert ()
  "Switch to Emacs state for editing."
  :repeat change
  (evil-emacs-state))

(define-key evil-emacs-state-map [escape] 'evil-normal-state)

;; Define a custom operator
(evil-define-operator my-evil-change-and-emacs-state (beg end type register yank-handler)
  "Change text from BEG to END with TYPE, REGISTER and YANK-HANDLER."
  :move-point nil
  (interactive "<R><x><y>")
  (evil-change beg end type register yank-handler)
  (evil-emacs-state))
;; Define other custom commands
;; Define other custom commands
(defun my-evil-append-line-and-emacs-state ()
  (interactive)
  (end-of-line)
  (evil-emacs-state))

(defun my-evil-append-and-emacs-state ()
  (interactive)
  (forward-char)
  (evil-emacs-state))

(defun my-evil-insert-line-and-emacs-state ()
  (interactive)
  (beginning-of-line)
  (evil-emacs-state))

(defun my-evil-insert-and-emacs-state ()
  (interactive)
  (evil-emacs-state))

(defun my-evil-open-below-and-emacs-state ()
  (interactive)
  (end-of-line)
  (newline-and-indent)
  (evil-emacs-state))

(defun my-evil-open-above-and-emacs-state ()
  (interactive)
  (beginning-of-line)
  (newline-and-indent)
  (previous-line)
  (evil-emacs-state))

(defun my-evil-change-line-and-emacs-state ()
  (interactive)
  (kill-whole-line)
  (evil-emacs-state))
(defun my-evil-insert-line-and-emacs-state ()
  (interactive)
  (evil-insert-line nil)
  (evil-emacs-state))

(defun my-evil-insert-and-emacs-state ()
  (interactive)
  (evil-insert nil)
  (evil-emacs-state))





(define-key evil-normal-state-map (kbd "A") 'my-evil-append-line-and-emacs-state)
(define-key evil-normal-state-map (kbd "a") 'my-evil-append-and-emacs-state)
(define-key evil-normal-state-map (kbd "O") 'my-evil-open-above-and-emacs-state)
(define-key evil-normal-state-map (kbd "o") 'my-evil-open-below-and-emacs-state)
(define-key evil-operator-state-map (kbd "C") 'my-evil-change-and-emacs-state)
(define-key evil-normal-state-map (kbd "I") 'my-evil-insert-line-and-emacs-state)
(define-key evil-normal-state-map (kbd "i") 'my-evil-insert-and-emacs-state)
;;;; new way
(defvar my-override-keymap (make-sparse-keymap))
(defun my-toggle-off-god-mode-and-evil-normal-state ()
  "Turn off god-mode if it's on, and bring to evil-normal-state."
  (interactive)
  (when (bound-and-true-p god-local-mode)
    (god-mode-all))  ;; Toggle off god-mode if it's on
  (unless (eq evil-state 'normal)
    (evil-normal-state)))  ;; Switch to evil-normal-state if not already in it

(define-minor-mode my-override-mode
  "Minor mode for overriding key bindings."
  :global t
  :init-value t
  :keymap my-override-keymap)

(define-key my-override-keymap (kbd "C-;") 'my-toggle-off-god-mode-and-evil-normal-state)
;;(define-key my-override-keymap (kbd "C-[") 'my-toggle-off-god-mode-and-evil-normal-state)
(define-key evil-emacs-state-map [escape]  'my-toggle-off-god-mode-and-evil-normal-state)
;;;; old way
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

;; one way of trying to preserve state

;; Set up the variable to hold the buffer state.
;;(defvar my-buffer-states (make-hash-table :test 'equal))
;;
;;(defun my-store-buffer-state ()
;;  "Store the current buffer state."
;;  (unless (minibufferp)
;;    (let* ((buffer-name (buffer-name))
;;           (evil-state evil-state)
;;           (god-local-mode god-local-mode))
;;      (puthash buffer-name (list evil-state god-local-mode) my-buffer-states))))
;;
;;(add-hook 'buffer-list-update-hook 'my-store-buffer-state)
;;(add-hook 'minibuffer-setup-hook 'my-store-buffer-state)
;;
;;(defun my-restore-buffer-state ()
;;  "Restore the buffer state."
;;  (let* ((buffer-name (buffer-name))
;;         (buffer-state (gethash buffer-name my-buffer-states)))
;;    (when buffer-state
;;      (setq evil-default-state (car buffer-state))  ;; Set evil-default-state to old evil state
;;      (evil-change-state (car buffer-state))
;;      (god-local-mode (if (cadr buffer-state) 1 -1)))))
;;
;;(add-hook 'buffer-list-update-hook 'my-restore-buffer-state)
;;(add-hook 'minibuffer-exit-hook 'my-restore-buffer-state)
;;
;;(defun my-preserve-modes ()
;;  "Preserve the current modes when switching buffers."
;;  (unless (minibufferp)
;;    (let* ((old-buffer (other-buffer (current-buffer) 1))
;;           (old-evil-state (with-current-buffer old-buffer evil-state))
;;           (old-god-local-mode (with-current-buffer old-buffer god-local-mode)))
;;      (when old-evil-state
;;        (setq evil-default-state old-evil-state)  ;; Set evil-default-state to old-evil-state
;;        (evil-change-state old-evil-state))
;;      (god-local-mode (if old-god-local-mode 1 -1))
;;      (my-god-mode-cursor-restore))))
;;
;;(add-hook 'buffer-list-update-hook 'my-preserve-modes)

(set-frame-font "Input Mono-6.5" t t)

(setq scroll-margin 3)


(setq scroll-conservatively 10000)

