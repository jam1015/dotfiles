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
  (define-key dired-mode-map (kbd "M-e") #'my/dired-open-eshell-here))


;;; ============================================================
;;; PERSPECTIVE
;;; ============================================================

(defun my/mappings-perspective ()
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "ps" #'persp-frame-switch          ; switch *this frame's* perspective
      "pS" #'persp-switch                 ; same, but persp-mode's generic entry point
      "pk" #'persp-kill
      "pn" #'persp-next
      "pp" #'persp-prev
      "pr" #'persp-rename
      "pA" #'persp-add-buffer
      "pR" #'persp-remove-buffer
      "pb" #'persp-switch-to-buffer
      "pi" #'persp-import-buffers)))     ; replaces perspective.el's `persp-merge'


(provide 'package-mappings)
;;; end package-mappings.el
