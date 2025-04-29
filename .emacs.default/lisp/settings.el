(setq-default inhibit-startup-screen t)
(blink-cursor-mode 0)
(setq-default visible-bell 1)
(set-frame-font "InputMonoNerdFont-8" t t)
(setq-default scroll-margin 3)
(setq-default scroll-conservatively 10000)
(save-place-mode 1)
;;(load-theme 'nord)
;;(add-hook 'window-setup-hook (lambda () (load-theme 'nord t)))
;;(load-theme 'nord t)
(add-hook 'elpaca-after-init-hook
	  (lambda () 
      (load-theme 'solarized-light t)
     (setq cursor-in-non-selected-windows nil)


	    )
)

(require 'which-key)
(which-key-mode)

(setq debug-on-error t)


     (setq cursor-in-non-selected-windows nil)

(setq-default cursor-in-non-selected-windows nil)

;; A few more useful configurations...
(use-package emacs
  :ensure nil
  :demand t
  :custom

     (setq cursor-in-non-selected-windows nil)
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))
(provide 'settings)
