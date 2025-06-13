(require 'elpaca-setup) ;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
;;(load-relative "straight_setup.el")

;;; code
(use-package god-mode
  
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (define-key god-local-mode-map (kbd ".") #'repeat))

(use-package geiser-mit
 :after corfu
  :config
  (dolist (hook '(geiser-repl-mode-hook
                  geiser-mode-hook    ; for Scheme source buffers
                  scheme-mode-hook))  ; if you ever open plain scheme-mode
    (add-hook hook
              (lambda ()
                (setq-local corfu-auto        nil
                            corfu-auto-delay  0.25
                            corfu-auto-prefix 1))))



;; Bind in both REPL and source buffers


;; 1) Your space handler
(defun my/geiser-space-insert ()
  "If Corfu is showing, quit it; then insert a space unconditionally."
  (interactive)
  (when (and (bound-and-true-p corfu-mode)
             (fboundp #'corfu--popup-visible-p)
             (corfu--popup-visible-p))
    (corfu-quit))
  (self-insert-command 1))

;; 2) Bind SPC in Evil’s insert state for Geiser & Scheme
(dolist (map '(geiser-mode-map
               geiser-repl-mode-map
               scheme-mode-map))
  (when (boundp map)
    (evil-define-key 'insert
      ;; must unwrap the symbol to the actual keymap variable
      (symbol-value map)
      (kbd "SPC") #'my/geiser-space-insert)))



  )

(use-package undo-tree
  :init
  (global-undo-tree-mode 1))
;; in your init.el or config.el
(use-package anzu
  :config
  (global-anzu-mode +1)) ;; turn on match counting globally

(use-package evil-anzu
  :after (evil anzu)) ;; hook anzu into evil’s ex/search


(use-package evil
  
  :after which-key
  ;;:after undo-tree
  :init


  (setq evil-want-keybinding nil
	evil-want-integration t)

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


;;(use-package company
;;  :hook (scheme-mode . company-mode)
;;  :custom
;;  (company-idle-delay nil)         ;; don’t auto-popup Company
;;  (company-minimum-prefix-length 2))
;;
;;(use-package company-geiser
;;  :after (company geiser))


(use-package evil-collection
  :after evil which-key
  
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



(use-package flycheck
  :defer t
  :init
  ;;(global-flycheck-mode)
  :config ;;(add-hook 'after-init-hook #'global-flycheck-mode)
 ;; optional
  ;;(setq flycheck-disabled-checkers '(emacs-lisp emacs-lisp-ela))
 (flycheck-add-mode 'emacs-lisp-checkdoc 'emacs-lisp-mode)
 :hook ((prog-mode       . flycheck-mode)
          (emacs-lisp-mode . flycheck-mode))
  )

(use-package package-lint)

(use-package flycheck-package
  :after flycheck
  :config
  (flycheck-package-setup)
  )

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
  :after (evil god-mode cursor-contraster which-key)
  :init

  :config
 
  ;; 1) Enable the global minor mode (so its keymap + lighter are active)
  (evil-god-toggle-mode 1)

  ; 2) Core toggle binding in the minor-mode’s keymap
;    (define-key evil-god-toggle-mode-map (kbd "C-;")
;  	      #'evil-god-toggle--god-toggle)



    (evil-define-key '(god) evil-god-toggle-mode-map  (kbd "C-;")
  	      (lambda () (interactive)
               (evil-god-toggle--stop-choose-state 'insert)))





  ;; 3) State‑specific bindings in that same map:

  (evil-define-key '(god-off normal insert)
    evil-god-toggle-mode-map
    (kbd "C-;") (lambda () (interactive)
                  (evil-god-toggle-execute-in-god-state)))


  (evil-define-key '(god god-off) evil-god-toggle-mode-map
    [escape] (lambda () (interactive) (evil-god-toggle-stop-choose-state 'normal)))

  (evil-define-key '( god-off) evil-god-toggle-mode-map
    (kbd "C-;") (lambda () (interactive) (evil-god-toggle-execute-in-god-state)))

  (evil-define-key '(god) evil-god-toggle-mode-map
    (kbd "C-;") (lambda () (interactive) (evil-god-toggle-execute-in-god-off-state)))

  (evil-define-key '(normal insert)
    evil-god-toggle-mode-map
    (kbd "C-,") #'evil-god-toggle-once)

  ;; 4) Your visual‑persistence and global flag settings
  (setq evil-god-toggle-persist-visual 'always
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



(use-package vertico
  :init
  (vertico-mode)
  (setq completion-styles '(basic substring partial-completion flex))
  :custom
  (vertico-count 15)
  (vertico-resize t)
  (vertico-cycle t)  ;; wrap at top/bottom
  :bind
  (:map vertico-map
        ;; navigation
        ("TAB"       . vertico-next)
        ("<tab>"     . vertico-next)
        ("S-TAB"     . vertico-previous)
        ("<backtab>" . vertico-previous)
        ;; insertion & completion
        ("C-SPC"     . vertico-insert)
        ("?"         . minibuffer-completion-help)
        ("M-RET"     . minibuffer-force-complete-and-exit)
        ("M-TAB"     . minibuffer-complete)))


(use-package corfu
  :ensure t
  :init
  ;; Enable Corfu globally
  (global-corfu-mode)

  :custom
  (corfu-count 25)
  (corfu-cycle t)                      ;; wrap at ends
  (corfu-auto t)                       ;; popup as you type
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)                ;; start completing after 1 char
  (corfu-preselect 'prompt)
  (corfu-quit-at-boundary 'separator)  ;; stay open on "/" boundary
  (corfu-quit-no-match 'separator)     ;; stay open even when no match

  :bind
  (:map corfu-map
        ;;("<return>" . corfu-send)
        ;;("RET" . corfu-send)
        ("TAB"       . corfu-next)
        ("<tab>"     . corfu-next)
        ("S-TAB"     . corfu-previous)
        ("<backtab>" . corfu-previous)
         ("C-SPC" . corfu-insert   )
	)

  :config
;; ─── Debug Corfu popup ─────────────────────────────────────────────────
(advice-add 'corfu--show :before (lambda (&rest _) (message "⟫ Corfu popup SHOW")))
(advice-add 'corfu--hide :before (lambda (&rest _) (message "⟪ Corfu popup HIDE")))

;; In your config, after Corfu is set up:
(defun my/eshell-corfu-return ()
  "In Eshell, if Corfu popup is visible insert completion, then send input."  
  (interactive)
  (if (and (bound-and-true-p corfu-mode)
           (fboundp 'corfu--popup-visible-p)
           (corfu--popup-visible-p))
      (progn
        (corfu-insert)      ;; accept the Corfu candidate
        (eshell-send-input))
    (eshell-send-input))) ;; normal RET

(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key (kbd "RET")      #'my/eshell-corfu-return)
            (local-set-key (kbd "<return>") #'my/eshell-corfu-return)))

;; ─── Helper to inspect what RET is bound to ──────────────────────────────────

(defun my/debug-ret-key ()
  (interactive)
  (message "DEBUG: RET maps to %S"
           (key-binding (kbd "RET"))))

;; Bind C-c RET in corfu-popup and in all minibuffers
(define-key corfu-map  (kbd "C-c RET") #'my/debug-ret-key)
(add-hook 'minibuffer-setup-hook
          (lambda () (local-set-key (kbd "C-c RET") #'my/debug-ret-key)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup my/corfu-strip nil
  "Strip trailing slash from real-directory completions in Corfu."
  :group 'corfu)

(defun my/corfu--strip-slash (s)
  "If S ends in “/” and is a real directory, drop the slash."
  (if (and (stringp s)
           (string-suffix-p "/" s)
           (file-directory-p s))
      (directory-file-name s)
    s))

(defun my/corfu--replace-advice (orig beg end str)
  "Advice around `corfu--replace' to drop trailing “/” on directories."
  (funcall orig beg end (my/corfu--strip-slash str)))

(defun my/corfu--preview-advice (&rest _)
  "Advice after `corfu--preview-current' to drop trailing “/” in the inline preview."
  (when (overlayp corfu--preview-ov)
    (let* ((ov   corfu--preview-ov)
           (disp (overlay-get ov 'display))
           (clean (and (stringp disp) (my/corfu--strip-slash disp))))
      (when clean
        (overlay-put ov 'display clean)))))

;;;###autoload
(define-minor-mode my/corfu-dir-strip-mode
  "Toggle stripping trailing slash for directory candidates in Corfu."
  :global t
  :group 'my/corfu-strip
  (if my/corfu-dir-strip-mode
      (progn
        ;; enable
        (advice-add 'corfu--replace         :around #'my/corfu--replace-advice)
        (advice-add 'corfu--preview-current :after  #'my/corfu--preview-advice))
    (progn
      ;; disable
      (advice-remove 'corfu--replace         #'my/corfu--replace-advice)
      (advice-remove 'corfu--preview-current #'my/corfu--preview-advice))))


;; Turn it on by default:
(my/corfu-dir-strip-mode 1)


)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic partial-completion))
  (completion-category-defaults nil)
  (completion-category-overrides '((file ( styles partial-completion)))))


(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))  

(use-package consult
  :after vertico
  :bind (;; Replace default bindings:
         ("C-s"     . consult-line)             ; search in buffer :contentReference[oaicite:12]{index=12}
         ("C-x b"   . consult-buffer)           ; enhanced buffer switch :contentReference[oaicite:13]{index=13}
         ("C-x C-r" . consult-recent-file)      ; recent files :contentReference[oaicite:14]{index=14}
         ("M-y"     . consult-yank-pop)         ; better yank history :contentReference[oaicite:15]{index=15}
         )
  :hook (completion-list-mode . consult-preview-at-point-mode) ; live previews
  :custom
   (consult-preview-key "any")
  )

(use-package embark
  :bind (("C-." . embark-act)                   ; act on target :contentReference[oaicite:16]{index=16}
         ("C-;" . embark-dwim)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)           ; collect candidates :contentReference[oaicite:17]{index=17}
         ("C-c C-e" . embark-export))           ; export to dedicated buffer :contentReference[oaicite:18]{index=18}
  :init
  (setq prefix-help-command #'embark-prefix-help-command))


(use-package embark-consult
  :after (embark consult)                       ; glue for Embark+Consult :contentReference[oaicite:19]{index=19}
  :demand t
  :config

(setf (alist-get 'consult-location embark-exporters-alist)
      #'embark-consult-export-location-grep)
(add-hook 'embark-collect-mode-hook #'consult-preview-at-point)
  )

(use-package wgrep
  :after grep
  :bind (:map grep-mode-map                    ; keybindings in `grep-mode'
              ("e"       . wgrep-change-to-wgrep-mode)  ; start editing :contentReference[oaicite:20]{index=20}
              ("C-x C-q" . wgrep-change-to-wgrep-mode)
              ("C-c C-c" . wgrep-finish-edit))          ; apply edits :contentReference[oaicite:21]{index=21}
  :custom
  (wgrep-auto-save-buffer t))    

(use-package cape
  :after (corfu geiser)  
  :init
  ;; Register the CAPE backends you want. Order matters: file first, then others.
  (add-hook 'completion-at-point-functions #'cape-file)
  :config
  ;; Protect Geiser’s CAPF from interruption
  (advice-add #'geiser-completion-at-point
              :around #'cape-wrap-noninterruptible))




;; lisp/packages.el





(use-package dirvish
  :after dired
  :init
  

  :config
  ;; override vanilla Dired
  (dirvish-override-dired-mode)





  ;; extras for layout-switch/toggle commands
  (require 'dirvish-extras)   ;; L = switch layouts, T = toggle preview

  (use-package all-the-icons :defer t)

  )

(use-package which-key
  :ensure nil
  :init
  (setq
   ;;which-key-allow-evil-operator;s t
   ;;which-key-show-operator-state-maps t
   which-key-idle-delay 0.2
   which-key-idle-secondary-delay 0.05
   which-key-popup-type 'side-window
   which-key-side-window-location 'bottom
   which-key-side-window-max-height 0.25
   which-key-sort-order 'which-key-prefix-then-key-order
   which-key-sort-uppercase-first nil
   which-key-separator " → "
   which-key-prefix-prefix "+ ")
  :config
  (which-key-mode 1)
  (which-key-enable-god-mode-support)


  )


(use-package evil-textobj-entire
  :ensure t
            :after evil
	    :config
 (define-key evil-outer-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer)
 (define-key evil-inner-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer)
	    )

;; use-package with Elpaca:
(use-package dashboard
  :if (< (length command-line-args) 2)
  :init
  (require 'cl-lib)
  :config

  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))



(use-package elisp-lint
  :ensure t
  :commands (elisp-lint-files-batch))

:config


(defun my/elisp-lint-current-file ()
  "Run elisp-lint on the current buffer's file."
  (interactive)
  (when buffer-file-name
    (elisp-lint-files-batch buffer-file-name)))


(define-key emacs-lisp-mode-map (kbd "C-c l") #'my/elisp-lint-current-file)



(use-package gnus
  :defer t
  :ensure nil
  :init
  (setq user-full-name "Jordan Mandel"
        user-mail-address "jordan.mandel@live.com"
        gnus-select-method
        '(nntp "news.eternal-september.org"
               (nntp-authinfo-file "~/.authinfo")
               (nntp-open-connection-function nntp-open-tls-stream)
               (nntp-port-number 563))
        gnus-read-active-file 'some
        gnus-use-cache t))


(provide 'packages)
