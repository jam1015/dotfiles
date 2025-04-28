(require 'elpaca-setup) ;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
;;(load-relative "straight_setup.el")

(use-package god-mode
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (define-key god-local-mode-map (kbd ".") #'repeat))

(use-package geiser-mit :ensure t)

(use-package undo-tree
  :demand t
  :init
  (global-undo-tree-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-overriding-maps nil)
  (evil-collection-init)
  )

(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl"))  ;; or whatever Lisp you use (e.g., ccl, ecl)

(use-package sly-quicklisp
  :after sly)

(use-package sly-asdf
  :after sly)



(use-package evil
  ;;:after undo-tree
  :init
  (setq evil-want-keybinding nil)

  

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
  )


(add-to-list 'load-path (expand-file-name "~/.emacs.d/package-folder/"))

(use-package restart-emacs
  :init (setq restart-emacs-restore-frames t)
  )

(use-package cursor-contraster
  :ensure (:host github
                 :repo "jam1015/cursor-contraster"
                 :after (evil god-mode)))

(use-package evil-god-toggle
  :ensure (:host github
                 :repo "jam1015/evil-god-toggle"
                 :after (evil god-mode cursor-contraster))
  :init

  :config
  ;;(require 'cursor-contraster)
  ;; 1) Enable the global minor mode (so its keymap + lighter are active)
  (evil-god-toggle-mode 1)

  ;; 2) Core toggle binding in the minor-mode’s keymap
;;  (define-key evil-god-toggle-mode-map (kbd "C-;")
;;	      #'evil-god-toggle--god)

  ;; 3) State‑specific bindings in that same map:
  (evil-define-key 'god
  evil-god-toggle-mode-map
  (kbd "C-;") (lambda () (interactive)
                (evil-change-to-previous-state)))

(evil-define-key '(normal insert)
  evil-god-toggle-mode-map
  (kbd "C-;") (lambda () (interactive)
                (evil-god-toggle--execute-in-god-state)))

;  (evil-define-key 'god-off
;    evil-god-toggle-mode-map
;    [escape] (lambda () (interactive)
;               (evil-god-toggle--stop-choose-state 'normal)))

  (evil-define-key '(god god-off) evil-god-toggle-mode-map
    [escape] (lambda () (interactive) (evil-god-toggle--bail)))



  (evil-define-key '(normal insert)
    evil-god-toggle-mode-map
    (kbd "C-,") #'evil-god-toggle--once)

  ;; 4) Your visual‑persistence and global flag settings
  (setq evil-god-toggle-persist-visual 'always
        evil-god-toggle-global        t)

  (cursor-contraster-mode 1)
  (cursor-contraster-setup-with-specs
   '((:var evil-god-state-cursor     :shape box    :index 1)
     (:var evil-god-off-state-cursor :shape bar    :index 2)
     (:var evil-insert-state-cursor  :shape bar    :index 3)
     (:var evil-visual-state-cursor  :shape hollow :index 4)
     (:var evil-normal-state-cursor  :shape hollow :index 8)))


  )

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)

  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))


(use-package anisochromatic-theme
  :ensure (:host github :repo "isomatter-labs/anisochromatic-emacs" )
  )

(use-package solarized-theme
  :ensure t
  )

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package xclip
  :config
  (xclip-mode 1))  ; Enable system clipboard support for * and + registers

;;(use-package nord-theme :demand t)

(provide 'packages)
