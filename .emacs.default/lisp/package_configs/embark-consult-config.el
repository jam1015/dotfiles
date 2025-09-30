(use-package embark-consult
  :after (embark consult)                       ; glue for Embark+Consult :contentReference[oaicite:19]{index=19}
  :demand t
  :config

(setf (alist-get 'consult-location embark-exporters-alist)
      #'embark-consult-export-location-grep)
(add-hook 'embark-collect-mode-hook #'consult-preview-at-point)
  )
(provide 'embark-consult-config)
