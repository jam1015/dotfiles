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

;;;; tree sitter
;;(use-package tree-sitter
;;  :config
;;  ;;(add-hook 'markdown-mode-hook #'tree-sitter-hl-mode)
;;  (global-tree-sitter-mode)
;;  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;  )

;;(use-package tree-sitter-langs)
;;(require 'tree-sitter)
;;(require 'tree-sitter-langs)



;;(use-package markdown-mode
;;  :ensure t
;;  :mode ("README\\.md\\'" . gfm-mode)
;;  :init (setq markdown-command "multimarkdown"))



;;(use-package ace-window
;;  :bind
;;  (("M-o" . ace-window))
;;  )

;;;; Enable ace-window and assign a keybinding
;;(global-set-key (kbd "M-o") 'ace-window)

;;;; Install Zenburn theme
;;(straight-use-package 'zenburn-theme)
;;;; Load Zenburn theme on startup
;;(load-theme 'zenburn t)


;;(straight-use-package
;; '(sly :type git :host github :repo "joaotavora/sly" :branch "master"))

;;(require 'sly-autoloads)

;;(setq sly-lisp-implementations
;;      '(
;;	(sbcl ("/usr/bin/sbcl") :coding-system utf-8-unix) (clisp ("/usr/bin/clisp" "-K full") :coding-system utf-8-unix)))

;;(eval-after-load 'sly
;;  `(define-key sly-prefix-map (kbd "M-h") 'sly-documentation-lookup))

(straight-use-package 'god-mode)
;;(setq god-exempt-major-modes nil)
;;(setq god-exempt-predicates nil)
;;(require 'god-mode)
;;;;(god-mode)
;;(use-package undo-tree)

( use-package evil
  :ensure t
 ;; :init
 ;; (setq evil-want-keybinding nil)
 ;; (global-undo-tree-mode)
 ;; (setq evil-undo-system 'undo-tree)
 ;; (add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
  )

;;(straight-use-package 'evil-leader)
;;
;;(global-evil-leader-mode)

;;(setq evil-want-keybinding nil)
;;(require 'evil-leader)
;;
(require 'evil)

(unless (and (featurep 'evil) evil-mode)
  (require 'evil)
  (evil-mode 1)
  (setq evil-default-state 'normal)
  ;;(evil-emacs-state)
  )
;;
;;(straight-use-package 'evil-collection)
;;(use-package evil-collection
;;  :straight t
;;  :after evil
;;  :config
;;  (evil-collection-init)
;;  )

;;(load-file "~/.emacs.default/evil-god_config.el")

;;(straight-use-package 'emmet-mode)
;;(straight-use-package 'web-mode)
;;(defun my-web-mode-hook ()
;;  "Hooks for Web mode."
;;  (setq web-mode-enable-auto-closing t)
;;  (setq web-mode-enable-auto-quoting t)
;;  (setq web-mode-enable-current-element-highlight t)
;;  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
;;  ;; Enable Emmet mode: https://github.com/smihica/emmet-mode
;;  (emmet-mode)
;;  )
;;(add-hook 'web-mode-hook  'my-web-mode-hook)
;;;; Associate jsx files with web-mode
;;(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
;;;; Enable JSX in emmet-mode
;;(with-eval-after-load 'emmet-mode
;;  (add-to-list 'emmet-jsx-major-modes 'web-mode))
;;
;;(straight-use-package 'which-key)
;;(which-key-mode 1)
;;(setq which-key-allow-evil-operators t)
;;(setq which-key-show-operator-state-maps t)
;;(which-key-enable-god-mode-support)

(use-package
 evil-god-state 
:straight `(evil-god-state
 :type git 
 :repo "file://~/Documents/evil_god_state_container/evil-god-state"
    :local-repo "~/Documents/evil_god_state_container/evil-god-state"
    :branch "evil_god_persistent"
	)
:config

(progn
(require 'evil-god-state)

(global-set-key (kbd "C-;") (lambda () (interactive) (god-toggle t)))
(global-set-key (kbd "C-,") (lambda () (interactive) (god-toggle nil)))
(setq god_entry_strategy "default")
(setq persist_visual t)
(evil-define-key 'god global-map "C-;" (lambda () (interactive) (god-toggle t)))
(evil-define-key 'god global-map "C-," (lambda () (interactive) (god-toggle nil)))

(evil-define-key 'god global-map [escape] (lambda () (interactive) (evil-stop-execute-in-god-state nil)))

(setq evil-god-state-cursor '(box "Red"))
(setq evil-insert-state-cursor '(bar "Red"))
(setq evil-visual-state-cursor '(hollow "Red"))
(setq evil-normal-state-cursor '(box "White"))
)
 )


(defun mark-active-indicator ()
  "Return a string indicating if the mark is active."
  (if mark-active "[Mark]" ""))

;; Add the indicator to the mode line
(setq-default mode-line-format
              (append mode-line-format '((:eval (mark-active-indicator)))))

