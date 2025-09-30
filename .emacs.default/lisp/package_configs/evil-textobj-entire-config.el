(use-package evil-textobj-entire
  :ensure t
            :after evil
	    :config
 (define-key evil-outer-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer)
 (define-key evil-inner-text-objects-map evil-textobj-entire-key 'evil-entire-entire-buffer)
	    )

(provide 'evil-textobj-entire-config)
