(use-package consult
  ;;:ensure (:tag "3.4")
  :after vertico
  :custom
  (consult-preview-key 'any)
  :config
  (my/apply-package-mappings 'consult))

(provide 'consult-config)
;;;end consult-config.el
