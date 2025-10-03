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

(provide 'vertico-config)
;;;end vertico-config.el
