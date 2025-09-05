(setq-default inhibit-startup-screen t)
(blink-cursor-mode 0)
(setq byte-compile-warnings t)  ;; default is '(not obsolete)
(setq-default visible-bell 1)
(setq-default scroll-margin 3)
(setq-default scroll-conservatively 10000)
(save-place-mode 1)
;;(load-theme 'nord)
;;(add-hook 'window-setup-hook (lambda () (load-theme 'nord t)))
;;(load-theme 'nord t)
(add-hook 'elpaca-after-init-hook
	  (lambda () 
      (load-theme 'anisochromatic t)
     (setq cursor-in-non-selected-windows nil)

(set-frame-font "InputMonoNerdFont-10" t t)
;;(setq completion-in-region-function #'consult-completion-in-region)

;; which key ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(require 'which-key)
;;
;;;; make it pop up very quickly
;;(setq which-key-idle-delay            0.2   ; time to wait before popup
;;      which-key-idle-secondary-delay  0.05) ; shorter delay after first show
;;
;;;; use a bottom side-window, limited height
;;(setq which-key-popup-type            'side-window
;;      which-key-side-window-location  'bottom
;;      which-key-side-window-max-height 0.25) ; at most 25% of frame
;;
;;;; sorting: show prefixes first, then keys, and ignore case
;;(setq which-key-sort-order
;;      'which-key-prefix-then-key-order
;;      which-key-sort-uppercase-first nil)
;;
;;;; prettier arrows and spacing
;;(setq which-key-separator              " → "
;;      which-key-prefix-prefix          "+ ")
;;(which-key-mode)
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	    )
)

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


     (setq cursor-in-non-selected-windows nil)

(setq-default cursor-in-non-selected-windows nil)

;; A few more useful configurations...






(provide 'settings)
