;;; -*- lexical-binding: t; -*-
;;; package-mappings.el --- Centralized keybindings for all installed packages
;;
;; Each package's :config block calls (my/mappings-PACKAGE).


;;; ============================================================
;;; EVIL
;;; ============================================================





(defun my/mappings-evil ()
  (define-key evil-ex-completion-map (kbd "<tab>")     #'completion-at-point)
  (define-key evil-ex-completion-map (kbd "TAB")       #'completion-at-point)
  (define-key evil-ex-completion-map (kbd "<backtab>") #'completion-at-point)
  (define-key evil-ex-completion-map [up]              #'previous-complete-history-element)
  (define-key evil-ex-completion-map [down]            #'next-complete-history-element)
  (evil-ex-define-cmd "bd[elete]" #'my/kill-this-buffer)
  (evil-ex-define-cmd "wbd"       #'my/evil-write-and-bdelete))


;;; ============================================================
;;; EVIL-GOD-TOGGLE
;;; ============================================================

(defun my/mappings-evil-god-toggle ()
  ;; C-,: enter god from evil states; exit god to god-off
  (evil-define-key '(normal insert visual god-off)
    evil-god-toggle-mode-map
    (kbd "C-,") (lambda () (interactive) (evil-god-toggle-execute-in-god-state nil)))
  (evil-define-key '(god)
    evil-god-toggle-mode-map
    (kbd "C-,") (lambda () (interactive) (evil-god-toggle-execute-in-god-off-state nil)))
  ;; [escape]: return to normal from any god state
  (evil-define-key '(god god-off god-once)
    evil-god-toggle-mode-map
    [escape] (lambda () (interactive)
               (evil-god-toggle-stop-god-state-maybe-visual 'normal)))

  ;; C-': one-shot god-off mode
  (evil-define-key '(normal visual insert)
    evil-god-toggle-mode-map
    (kbd "C-'") (lambda () (interactive) (evil-god-toggle-off-once nil)))

  ;; C-;: one-shot god mode
  (evil-define-key '(normal visual insert)
    evil-god-toggle-mode-map
    (kbd "C-;") (lambda () (interactive) (evil-god-toggle-once nil))))


;;; ============================================================
;;; EVIL-LEADER
;;; ============================================================

(defun my/mappings-evil-leader ()
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "ee"    #'eshell
    "bb"    #'consult-buffer
    "bk"    #'my/kill-this-buffer
    "nh"    #'evil-search-highlight-persist-remove-all
    ":"     #'execute-extended-command
    "SPC :" #'eval-expression)
  ;; explicit sub-keymap alternative (commented out — "SPC :" should work natively)
  ;; (let ((spc-map (make-sparse-keymap)))
  ;;   (define-key spc-map (kbd ":") #'eval-expression)
  ;;   (define-key evil-leader--default-map (kbd "SPC") spc-map))
  )


;;; ============================================================
;;; EVIL-SEARCH-HIGHLIGHT-PERSIST
;;; ============================================================

(defun my/mappings-evil-search-highlight-persist ()
					;(evil-leader/set-key "ll" #'evil-search-highlight-persist-remove-all)
  )


;;; ============================================================
;;; EVIL-TEXTOBJ-ENTIRE
;;; ============================================================

(defun my/mappings-evil-textobj-entire ()
  (define-key evil-outer-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer)
  (define-key evil-inner-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer))


;;; ============================================================
;;; CORFU
;;; ============================================================

(defun my/evil-ex-corfu-send-and-execute ()
  "In Evil ex minibuffer, accept Corfu completion and execute."
  (interactive)
  (if (and (minibufferp)
	   (string-match-p "^:" (or (minibuffer-prompt) "")))
      (progn
        (when (>= corfu--index 0)
          (corfu-insert))
        (exit-minibuffer))
    (corfu-send)))

(defun my/mappings-corfu ()
  (define-key corfu-map (kbd "TAB")       #'corfu-next)
  (define-key corfu-map (kbd "<tab>")     #'corfu-next)
  (define-key corfu-map (kbd "S-TAB")     #'corfu-previous)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous)
  (define-key corfu-map (kbd "C-SPC")     #'corfu-insert)
  (define-key corfu-map (kbd "RET")       #'my/evil-ex-corfu-send-and-execute)
  (define-key corfu-map (kbd "<return>")  #'my/evil-ex-corfu-send-and-execute)
  (add-hook 'eshell-mode-hook
            (lambda ()
              (local-set-key (kbd "RET")      #'my/eshell-corfu-return)
              (local-set-key (kbd "<return>") #'my/eshell-corfu-return))))


;;; ============================================================
;;; VERTICO
;;; ============================================================

(defun my/mappings-vertico ()
  (define-key vertico-map (kbd "TAB")       #'vertico-next)
  (define-key vertico-map (kbd "<tab>")     #'vertico-next)
  (define-key vertico-map (kbd "S-TAB")     #'vertico-previous)
  (define-key vertico-map (kbd "<backtab>") #'vertico-previous)
  (define-key vertico-map (kbd "C-SPC")     #'vertico-insert)
  (define-key vertico-map (kbd "?")         #'minibuffer-completion-help)
  (define-key vertico-map (kbd "M-RET")     #'minibuffer-force-complete-and-exit)
  (define-key vertico-map (kbd "M-TAB")     #'minibuffer-complete))


;;; ============================================================
;;; CONSULT
;;; ============================================================

(defun my/mappings-consult ()
  (global-set-key (kbd "C-s")     #'consult-line)
  (global-set-key (kbd "C-x b")   #'consult-buffer)
  (global-set-key (kbd "C-x C-r") #'consult-recent-file)
  (global-set-key (kbd "M-y")     #'consult-yank-pop))


;;; ============================================================
;;; EMBARK
;;; ============================================================

(defun my/mappings-embark ()
  (global-set-key (kbd "C-.") #'embark-act)
  (global-set-key (kbd "C-;") #'embark-dwim)
  (define-key minibuffer-local-map (kbd "C-c C-c") #'embark-collect)
  (define-key minibuffer-local-map (kbd "C-c C-e") #'embark-export))


;;; ============================================================
;;; ELISP-LINT
;;; ============================================================

(defun my/mappings-elisp-lint ()
  (define-key emacs-lisp-mode-map (kbd "C-c l") #'my/elisp-lint-current-file))


;;; ============================================================
;;; PACKAGE-LINT
;;; ============================================================

(defun my/mappings-package-lint ()
  (define-key emacs-lisp-mode-map (kbd "C-c l") #'package-lint-current-buffer))


;;; ============================================================
;;; FLYCHECK
;;; ============================================================

(defun my/mappings-flycheck ()
  (define-key emacs-lisp-mode-map (kbd "C-c L") #'flycheck-list-errors))


;;; ============================================================
;;; REPL shared helpers
;;; ============================================================

(defun my/repl-space-insert ()
  "Dismiss Corfu popup if visible, then insert a space."
  (interactive)
  (when (and (bound-and-true-p corfu-mode)
             (fboundp #'corfu--popup-visible-p)
             (corfu--popup-visible-p))
    (corfu-quit))
  (self-insert-command 1))


;;; ============================================================
;;; SLY
;;; ============================================================

(defun my/mappings-sly ()
  (with-eval-after-load 'sly-mrepl
    (evil-define-key 'insert sly-mrepl-mode-map
      (kbd "SPC") #'my/repl-space-insert))
  (with-eval-after-load 'sly
    (evil-define-key 'insert sly-mode-map
      (kbd "SPC") #'my/repl-space-insert)))


;;; ============================================================
;;; SLIME
;;; ============================================================

(defun my/mappings-slime ()
  (with-eval-after-load 'slime-repl
    (evil-define-key 'insert slime-repl-mode-map
      (kbd "SPC") #'my/repl-space-insert))
  (with-eval-after-load 'slime
    (evil-define-key 'insert slime-mode-map
      (kbd "SPC") #'my/repl-space-insert)))


;;; ============================================================
;;; GEISER-MIT
;;; ============================================================

(defun my/mappings-geiser-mit ()
  (with-eval-after-load 'geiser-repl
    (evil-define-key 'insert geiser-repl-mode-map
      (kbd "SPC") #'my/repl-space-insert))
  (with-eval-after-load 'geiser-mode
    (evil-define-key 'insert geiser-mode-map
      (kbd "SPC") #'my/repl-space-insert))
  (with-eval-after-load 'scheme
    (evil-define-key 'insert scheme-mode-map
      (kbd "SPC") #'my/repl-space-insert)))


;;; ============================================================
;;; WGREP
;;; ============================================================

(defun my/mappings-wgrep ()
  (define-key grep-mode-map (kbd "e")       #'wgrep-change-to-wgrep-mode)
  (define-key grep-mode-map (kbd "C-x C-q") #'wgrep-change-to-wgrep-mode)
  (define-key grep-mode-map (kbd "C-c C-c") #'wgrep-finish-edit))


;;; ============================================================
;;; KKP
;;; ============================================================

(defun my/mappings-kkp ()
  (unless (display-graphic-p)
    (define-key key-translation-map (kbd "C-[")
		(lambda (_prompt) (if (display-graphic-p) nil [escape])))
    (define-key input-decode-map (kbd "C-m") [return])))


;;; ============================================================
;;; GOD-MODE
;;; ============================================================

(defun my/mappings-god-mode ()
  (define-key god-local-mode-map (kbd ".") #'repeat))


;;; ============================================================
;;; DIRED
;;; ============================================================

(defun my/dired-open-eshell-here ()
  "Open eshell in the current dired directory, bypassing whereami restore."
  (interactive)
  (let ((dir default-directory))
    (eshell)
    (eshell/cd dir)
    (eshell-reset)))

(defun my/mappings-dired ()
  (define-key dired-mode-map (kbd "M-e") #'my/dired-open-eshell-here)
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key-for-mode 'dired-mode
      "+" #'dired-create-empty-file)))


;;; ============================================================
;;; UNIMPAIRED
;;; ============================================================

(defun my/mappings-unimpaired ()
  (evil-collection-define-key 'normal 'evil-collection-unimpaired-mode-map
    "[t" #'tab-bar-switch-to-prev-tab
    "]t" #'tab-bar-switch-to-next-tab)
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "[t" #'xref-go-back
      "]t" #'xref-find-definitions)))


;;; ============================================================
;;; SLIME-EAT
;;; ============================================================

(defun my/mappings-slime-eat ()
  ;; `gz' is an evil operator; evil handles `gzz' as "operator on current
  ;; line" automatically (same convention as dd/yy/cc), so no separate binding.
  (evil-define-key '(normal visual) slime-eat-mode-map
    "gz" #'slime-eat-send-op))


;;; ============================================================
;;; EGLOT  (mirrors nvim LSP keymap)
;;; ============================================================
;; Layout:
;;   gd / gD / gi / gr        buffer-local in eglot-managed buffers
;;   [d / ]d                  prev/next diagnostic (eglot buffers only)
;;   <leader>l*               LSP actions (global; no-op if no server)
;;   <leader>lw*              workspace folders
;;   <leader>lt*              toggles (inlay hints, diagnostics)
;;   <leader>d*               diagnostics (open float, loclist)
;;
;; Conflict audit vs existing leader keys ("ee" "bb" "bk" "nh" ":"
;; "SPC :" "[t" "]t"): none — `l' and `d' are unused at top level.
;;
;; `gi' and `gd' are default evil bindings (insert-resume,
;; goto-definition); we rebind them only inside eglot-managed buffers
;; via `evil-define-key' on `eglot-mode-map', so normal evil behavior
;; is preserved everywhere else.

(defun my/eglot-diagnostic-open-float ()
  "Show flymake diagnostics at point in a popup (nvim :diagnostic.open_float)."
  (interactive)
  (if (fboundp 'flymake-show-buffer-diagnostics)
      (flymake-show-buffer-diagnostics)
    (message "no flymake")))

(defun my/eglot-format-buffer-or-region ()
  "Format region if active, else whole buffer (async)."
  (interactive)
  (if (use-region-p)
      (eglot-format (region-beginning) (region-end))
    (eglot-format-buffer)))

(defun my/eglot-toggle-inlay-hints ()
  "Toggle eglot inlay-hints in the current buffer."
  (interactive)
  (if (bound-and-true-p eglot-inlay-hints-mode)
      (progn (eglot-inlay-hints-mode -1) (message "Inlay hints disabled"))
    (eglot-inlay-hints-mode 1) (message "Inlay hints enabled")))

(defun my/eglot-toggle-diagnostics ()
  "Toggle flymake (eglot's diagnostics backend) in the current buffer."
  (interactive)
  (if (bound-and-true-p flymake-mode)
      (progn (flymake-mode -1) (message "Diagnostics disabled"))
    (flymake-mode 1) (message "Diagnostics enabled")))

(defun my/eglot-list-workspace-folders ()
  "Print the project root serving as eglot's workspace folder."
  (interactive)
  (if (not (eglot-current-server))
      (message "no eglot server")
    (let ((proj (project-current)))
      (message "project: %s" (and proj (project-root proj))))))

(defun my/mappings-eglot ()
  ;; Buffer-local navigation + diagnostic-nav inside eglot buffers.
  ;;
  ;; Keys marked [e-c] are also set by evil-collection's eglot module
  ;; (modes/eglot/evil-collection-eglot.el); listed here redundantly so
  ;; the full in-eglot keymap is visible in one place. Our definitions
  ;; run after evil-collection's, so these overrides win — most are
  ;; identical so the override is a no-op.
  (evil-define-key '(normal visual) eglot-mode-map
    ;;                                                     ;; source
    (kbd "gd")  #'xref-find-definitions                    ; [e-c] same
    (kbd "gD")  #'xref-find-references                     ; [e-c sets: xref-find-definitions-other-window]
                                                           ;   ours diverges — nvim parity (gD = declaration ≈ refs)
    (kbd "g5")  #'xref-find-definitions-other-frame        ; [e-c] redundant
    (kbd "C-t") #'xref-go-back                             ; [e-c sets: xref-pop-marker-stack, deprecated alias]
    (kbd "K")   #'eldoc-doc-buffer                         ; [e-c] redundant
    (kbd "gr")  #'xref-find-references                     ; [e-c] only when `evil-collection-want-find-usages-bindings'
    ;; Extras not in evil-collection:
    (kbd "gi")  #'eglot-find-implementation                ; ours
    (kbd "[d")  #'flymake-goto-prev-error                  ; ours
    (kbd "]d")  #'flymake-goto-next-error)                 ; ours

  ;; Global leader bindings (safe: commands error cleanly when no
  ;; server is attached, matching vim.lsp.buf.* behavior).
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
     ;; <leader>d — Diagnostics
     "de" #'my/eglot-diagnostic-open-float
     "dq" #'flymake-show-project-diagnostics

     ;; <leader>l — LSP
     "lh" #'eldoc-doc-buffer             ; hover
     "lk" #'eldoc                        ; signature help (eldoc shows it)
     "ld" #'eglot-find-typeDefinition
     "lr" #'eglot-rename
     "la" #'eglot-code-actions
     "lf" #'my/eglot-format-buffer-or-region

     ;; <leader>lw — workspace / server lifecycle
     ;; (eglot has no interactive add/remove-workspace-folder; closest
     ;; analogues are reconnect and shutdown-all.)
     "lws" #'eglot-shutdown-all
     "lwr" #'eglot-reconnect
     "lwl" #'my/eglot-list-workspace-folders

     ;; <leader>lt — toggles
     "lti" #'my/eglot-toggle-inlay-hints
     "ltl" #'eglot-code-action-quickfix ; eglot has no codelens UX; use QF
     "ltd" #'my/eglot-toggle-diagnostics)))


;;; ============================================================
;;; AUCTEX
;;; ============================================================

(defun my/mappings-auctex ()
  ;; Mirrors vimtex's LatexTextObjects: ad/id = whole buffer in tex/bib.
  (with-eval-after-load 'evil-textobj-entire
    (add-hook 'LaTeX-mode-hook
              (lambda ()
                (evil-define-key '(visual operator) 'local
                  (kbd "ad") #'evil-entire-entire-buffer
                  (kbd "id") #'evil-entire-entire-buffer)))
    (add-hook 'bibtex-mode-hook
              (lambda ()
                (evil-define-key '(visual operator) 'local
                  (kbd "ad") #'evil-entire-entire-buffer
                  (kbd "id") #'evil-entire-entire-buffer))))
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "mc" #'my/latex-latexmk
      "mv" #'TeX-view
      "mk" #'TeX-kill-job)))


(provide 'package-mappings)
;;; end package-mappings.el
