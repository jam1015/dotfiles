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

(provide 'consult-config)
;;;end consult-config.el
