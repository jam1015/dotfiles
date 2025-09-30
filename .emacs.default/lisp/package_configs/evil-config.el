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








(provide 'evil-config)
