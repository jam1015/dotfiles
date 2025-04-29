(require 'elpaca-setup) ;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
;;(load-relative "straight_setup.el")

(use-package god-mode
  
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (define-key god-local-mode-map (kbd ".") #'repeat))

(use-package geiser-mit :defer t)

(use-package undo-tree
  
  :demand t
  :init
  (global-undo-tree-mode 1))


(use-package evil
  
  ;;:after undo-tree
  :init

  (setq evil-want-keybinding nil)






  (setq evil-default-state 'normal)
  :custom
  (evil-undo-system 'undo-tree)
  (display-line-numbers-type 'relative)
  :config

  ;; Tab now invokes Emacs’s normal completion (completion-at-point)
  (define-key evil-ex-completion-map (kbd "<tab>") #'completion-at-point)     ;; Emacs completion-at-point :contentReference[oaicite:0]{index=0}
  (define-key evil-ex-completion-map (kbd "TAB")    #'completion-at-point)

  ;; Shift-Tab can also re-trigger completion if you like
  (define-key evil-ex-completion-map (kbd "<backtab>") #'completion-at-point)

  ;; Up/Down cycle Ex command-history entries
  (define-key evil-ex-completion-map [up]   #'previous-complete-history-element)   ;; minibuffer history :contentReference[oaicite:1]{index=1}
  (define-key evil-ex-completion-map [down] #'next-complete-history-element)
  (defun my/evil-write-and-bdelete ()
    "Save the current buffer, then kill it (like Vim’s :wbd)."
    (interactive)
    (save-buffer)
    (kill-this-buffer))

    (evil-ex-define-cmd "wbd" #'my/evil-write-and-bdelete)
  ;;(define-key evil-ex-completion-map (kbd "TAB")       #'evil-ex-complete)
  ;;(define-key evil-ex-completion-map (kbd "<tab>")     #'evil-ex-complete)
  ;;(define-key evil-ex-completion-map (kbd "<backtab>") #'evil-ex-complete)


  (evil-mode 1)
  (global-display-line-numbers-mode t)
  ;; Initialize savehist-additional-variables if it's void
  (unless (boundp 'savehist-additional-variables)
    (setq savehist-additional-variables nil))
  ;; Append 'evil-ex-history to savehist-additional-variables
  (add-to-list 'savehist-additional-variables 'evil-ex-history)
  ;; Turn on savehist-mode
  (savehist-mode 1)


  (evil-ex-define-cmd "ConsultLine" #'consult-line)
  (evil-ex-define-cmd "ConsultRg" #'consult-ripgrep)
  (evil-ex-define-cmd "ConsultFind" #'consult-find)
  (evil-ex-define-cmd "Mx" #'execute-extended-command)

  )


(use-package evil-collection
  :after evil
  
  :config
  (setq evil-overriding-maps nil)
  (evil-collection-init)
  )

(use-package sly
  
  :init
  (setq inferior-lisp-program "sbcl"))  ;; or whatever Lisp you use (e.g., ccl, ecl)

(use-package sly-quicklisp
  
  :after sly)

(use-package sly-asdf
  
  :after sly)






(use-package cursor-contraster
  :ensure (:host github
                 :repo "jam1015/cursor-contraster"
                 )
  :after (evil god-mode)
  :config
(cursor-contraster-mode 1)
(cursor-contraster-setup-with-specs
 '((:var evil-god-state-cursor     :shape box    :index 0)
   (:var evil-god-off-state-cursor :shape bar    :index 1)
   (:var evil-insert-state-cursor  :shape bar    :index 2)
   (:var evil-visual-state-cursor  :shape hollow :index 3)
   (:var evil-normal-state-cursor  :shape hollow :index 4)))

  
  )

(use-package evil-god-toggle
  :ensure (:host github
		 :repo "jam1015/evil-god-toggle"
		 )
  :after (evil god-mode cursor-contraster)
  :init

  :config
  
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
  (setq evil-god-toggle-persist-visual nil
        evil-god-toggle-global        t)








  )

(use-package evil-goggles
  
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

(use-package solarized-theme)

(use-package markdown-mode
             :defer t
  
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package xclip
  
  :config
  (xclip-mode 1))  ; Enable system clipboard support for * and + registers

(use-package vertico
  :init
  (vertico-mode)
  (setq completion-styles '(basic substring partial-completion flex))
  :custom
  (vertico-count 15)
  (vertico-resize t)
  (vertico-cycle t)  ;; wrap at top/bottom
  :config
(keymap-set vertico-map "?" #'minibuffer-completion-help)
(keymap-set vertico-map "M-RET" #'minibuffer-force-complete-and-exit)
(keymap-set vertico-map "M-TAB" #'minibuffer-complete)


  :bind
  (:map vertico-map
        ("TAB"       . vertico-next)
        ("<tab>"     . vertico-next)
        ("S-TAB"     . vertico-previous)
        ("<backtab>" . vertico-previous)
        ("C-SPC"     . vertico-insert)
        ))

(use-package corfu
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  ;; 1) Make sure file‐path completion treats “/” as a boundary:
  (setq completion-category-overrides '((file (styles partial-completion))))
  ;; 2) (Optional) if you use Orderless elsewhere, you might want:
  (setq completion-styles '(orderless basic partial-completion)
        completion-category-overrides '((file (styles partial-completion))))
  (global-corfu-mode)                  ; enable everywhere
  :custom
  (corfu-cycle t)                      ; wrap at ends
  (corfu-auto t)                       ; popup as you type
  (corfu-auto-delay 0.05)
  (corfu-auto-prefix 1)                ; start immediately
  (corfu-preselect 'prompt)
  (corfu-quit-at-boundary 'separator)         ; don’t quit on e.g. `/`
  (corfu-quit-no-match 'separator)            ; stay open even when no candidates
  :bind
  (:map corfu-map
        ("TAB"       . corfu-next)
        ("<tab>"     . corfu-next)
        ("S-TAB"     . corfu-previous)
        ("<backtab>" . corfu-previous)
)
  :config
  ;; file-and-path completion that understands `…/` and leaves the popup up:







  )

(use-package cape
  :ensure t
  ;;:after corfu
  :init
  ;;  Register the Capfs you want.  Order matters: try file first, then dabbrev, etc.
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-file)      ; directories and files
;;  (add-to-list 'completion-at-point-functions #'cape-dabbrev)   ; words from buffers
;;  (add-to-list 'completion-at-point-functions #'cape-history)   ; input histories (minibuffer, etc)
;;  (add-to-list 'completion-at-point-functions #'cape-keyword)   ; mode keywords (e.g. programming language)
;;  (add-to-list 'completion-at-point-functions #'cape-symbol)    ; symbols in buffer
;;  (add-to-list 'completion-at-point-functions #'cape-yasnippet) ; Yasnippet snippets
  ;;  (Optional) Merge them into a single Capf so you get a unified popup.
  ;;(add-to-list 'completion-at-point-functions
  ;;             (cape-capf-super
  ;;               #'cape-file
  ;;               #'cape-dabbrev
  ;;               #'cape-history
  ;;               #'cape-keyword
  ;;               #'cape-symbol
  ;;               #'cape-yasnippet)
  ;;             )
  ;;:bind
  ;;;; on-demand invocation
  ;;("C-c p p" . completion-at-point)
  ;;("C-c p f" . cape-file)
  ;;("C-c p d" . cape-dabbrev)
  ;;("C-c p h" . cape-history)
  ;;("C-c p k" . cape-keyword)
  ;;("C-c p s" . cape-symbol)
  ;;("C-c p y" . cape-yasnippet)
  )





;;─────────────────────────────────────────────────────────────────────────────
;; Notes:
;; - We removed the redundant first `setq` block; only one set of auto-popup
;;   settings remains.
;; - We dropped the `corfu-mode-hook` that forced `completion-styles` to `(basic)`
;;   so you can continue using orderless/flex matching elsewhere.
;; - If you *do* want per-mode completion-style overrides, consider doing it
;;   explicitly in those modes’ hooks, rather than unconditionally here.




(use-package consult
  :ensure t
  :after vertico
  :custom
  (consult-preview-key "any"))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act) ;; "Do something" prompt on selected minibuffer candidate
   ("C-;" . embark-dwim))) ;; "Do what I mean" action

(use-package embark-consult
  :ensure t
  :after (embark consult)) ;; for deeper consult-embark integration

(use-package dabbrev
             :ensure nil

    ;; Swap M-/ and C-M-/
    :bind (("M-/" . dabbrev-completion)
           ("C-M-/" . dabbrev-expand))
    :config
    (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
    ;; Available since Emacs 29 (Use `dabbrev-ignored-buffer-regexps' on older Emacs)
    (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
    (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
    (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
    (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode)
  )


;; Optionally use the `orderless' completion style.
(use-package orderless

  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(provide 'packages)
