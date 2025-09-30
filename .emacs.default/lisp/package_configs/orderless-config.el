(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic partial-completion))
  (completion-category-defaults nil)
  (completion-category-overrides '((file ( styles partial-completion)))))
(provide 'orderless-config)
