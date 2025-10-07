(use-package embark
  :bind (("C-." . embark-act)                   ; act on target :contentReference[oaicite:16]{index=16}
         ("C-;" . embark-dwim)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)           ; collect candidates :contentReference[oaicite:17]{index=17}
         ("C-c C-e" . embark-export))           ; export to dedicated buffer :contentReference[oaicite:18]{index=18}
  :init
  (setq prefix-help-command #'embark-prefix-help-command))


(provide 'embark-config)
;;;end embark-config.el
