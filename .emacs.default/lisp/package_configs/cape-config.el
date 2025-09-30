(use-package cape
  :after (corfu geiser)  
  :init
  ;; Register the CAPE backends you want. Order matters: file first, then others.
  (add-hook 'completion-at-point-functions #'cape-file)
  :config
  ;; Protect Geiser’s CAPF from interruption
  (advice-add #'geiser-completion-at-point
              :around #'cape-wrap-noninterruptible))

(provide 'cape-config)
