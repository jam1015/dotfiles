;;; package-mappings.el --- Centralized keybindings for all installed packages
;;
;; Each package's :config block calls (my/mappings-PACKAGE).

(defun my/dired-open-eshell-here ()
  "Open eshell in the current dired directory, bypassing whereami restore."
  (interactive)
  (let ((dir default-directory))
    (eshell)
    (eshell/cd dir)
    (eshell-reset)))

(defun my/send-region-to-repl (beg end)
  "Send region BEG to END to the appropriate REPL based on major mode."
  (cond
   ((derived-mode-p 'scheme-mode 'geiser-repl-mode)
    (geiser-eval-region beg end))
   ((derived-mode-p 'emacs-lisp-mode)
    (eval-region beg end))
   ((and (derived-mode-p 'lisp-mode) (bound-and-true-p sly-mode))
    (sly-eval-region beg end))
   ((and (derived-mode-p 'lisp-mode) (bound-and-true-p slime-mode))
    (slime-eval-region beg end))
   ((derived-mode-p 'python-mode)
    (python-shell-send-region beg end))
   (t (user-error "No REPL configured for %s" major-mode))))

(defun my/mappings-evil ()
  (evil-define-operator my/evil-send-to-repl (beg end)
    "Send motion/region to REPL. `gzz' sends current line, `gzap' a paragraph, etc."
    :move-point nil
    (my/send-region-to-repl beg end))
  (define-key evil-ex-completion-map (kbd "<tab>")     #'completion-at-point)
  (define-key evil-ex-completion-map (kbd "TAB")       #'completion-at-point)
  (define-key evil-ex-completion-map (kbd "<backtab>") #'completion-at-point)
  (define-key evil-ex-completion-map [up]              #'previous-complete-history-element)
  (define-key evil-ex-completion-map [down]            #'next-complete-history-element)
  (evil-ex-define-cmd "bd[elete]" #'my/kill-this-buffer)
  (evil-ex-define-cmd "wbd"       #'my/evil-write-and-bdelete)
  (define-key evil-normal-state-map "gz" #'my/evil-send-to-repl))

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

(defun my/mappings-evil-leader ()
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "ee"    #'eshell
    "bb"    #'switch-to-buffer
    "bk"    #'my/kill-this-buffer
    "nh"    #'evil-search-highlight-persist-remove-all
    ":"     #'execute-extended-command
    "SPC :" #'eval-expression)
  ;; explicit sub-keymap alternative (commented out — "SPC :" should work natively)
  ;; (let ((spc-map (make-sparse-keymap)))
  ;;   (define-key spc-map (kbd ":") #'eval-expression)
  ;;   (define-key evil-leader--default-map (kbd "SPC") spc-map))
  )

(defun my/mappings-evil-search-highlight-persist ()
					;(evil-leader/set-key "ll" #'evil-search-highlight-persist-remove-all)
  )

(defun my/mappings-consult ()
  (global-set-key (kbd "C-s")     #'consult-line)
  (global-set-key (kbd "C-x b")   #'consult-buffer)
  (global-set-key (kbd "C-x C-r") #'consult-recent-file)
  (global-set-key (kbd "M-y")     #'consult-yank-pop))

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

(defun my/mappings-embark ()
  (global-set-key (kbd "C-.") #'embark-act)
  (global-set-key (kbd "C-;") #'embark-dwim)
  (define-key minibuffer-local-map (kbd "C-c C-c") #'embark-collect)
  (define-key minibuffer-local-map (kbd "C-c C-e") #'embark-export))

(defun my/mappings-elisp-lint ()
  (define-key emacs-lisp-mode-map (kbd "C-c l") #'my/elisp-lint-current-file))

(defun my/mappings-geiser-mit ()
  (dolist (map '(geiser-mode-map geiser-repl-mode-map scheme-mode-map))
    (when (boundp map)
      (evil-define-key 'insert (symbol-value map)
        (kbd "SPC") #'my/geiser-space-insert))))

(defun my/mappings-vertico ()
  (define-key vertico-map (kbd "TAB")       #'vertico-next)
  (define-key vertico-map (kbd "<tab>")     #'vertico-next)
  (define-key vertico-map (kbd "S-TAB")     #'vertico-previous)
  (define-key vertico-map (kbd "<backtab>") #'vertico-previous)
  (define-key vertico-map (kbd "C-SPC")     #'vertico-insert)
  (define-key vertico-map (kbd "?")         #'minibuffer-completion-help)
  (define-key vertico-map (kbd "M-RET")     #'minibuffer-force-complete-and-exit)
  (define-key vertico-map (kbd "M-TAB")     #'minibuffer-complete))

(defun my/mappings-wgrep ()
  (define-key grep-mode-map (kbd "e")       #'wgrep-change-to-wgrep-mode)
  (define-key grep-mode-map (kbd "C-x C-q") #'wgrep-change-to-wgrep-mode)
  (define-key grep-mode-map (kbd "C-c C-c") #'wgrep-finish-edit))

(defun my/mappings-kkp ()
  (unless (display-graphic-p)
    (define-key key-translation-map (kbd "C-[")
	    (lambda (_prompt) (if (display-graphic-p) nil [escape])))
    (define-key input-decode-map (kbd "C-m") [return])))

(defun my/mappings-god-mode ()
  (define-key god-local-mode-map (kbd ".") #'repeat))

(defun my/mappings-evil-textobj-entire ()
  (define-key evil-outer-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer)
  (define-key evil-inner-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer))

(defun my/mappings-dired ()
  (define-key dired-mode-map (kbd "M-e") #'my/dired-open-eshell-here))

(provide 'package-mappings)
;;; end package-mappings.el
