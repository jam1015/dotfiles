(use-package wgrep
  :after grep
  :bind (:map grep-mode-map                    ; keybindings in `grep-mode'
              ("e"       . wgrep-change-to-wgrep-mode)  ; start editing :contentReference[oaicite:20]{index=20}
              ("C-x C-q" . wgrep-change-to-wgrep-mode)
              ("C-c C-c" . wgrep-finish-edit))          ; apply edits :contentReference[oaicite:21]{index=21}
  :custom
  (wgrep-auto-save-buffer t))

(provide 'wgrep-config)
