(setq inhibit-startup-screen t)
(blink-cursor-mode 0)
(setq visible-bell 1)
(set-frame-font "Courier Prime-14" t t)
(setq scroll-margin 3)
(setq scroll-conservatively 10000)
(save-place-mode 1)
;;(load-theme 'nord)
;;(add-hook 'window-setup-hook (lambda () (load-theme 'nord t)))
;;(load-theme 'nord t)
(add-hook 'elpaca-after-init-hook
          ;;(lambda () (load-theme 'nord t))

          (custom-set-variables
            ;; custom-set-variables was added by Custom.
            ;; If you edit it by hand, you could mess it up, so be careful.
            ;; Your init file should contain only one such instance.
            ;; If there is more than one, they won't work right.
            '(custom-enabled-themes '(wheatgrass))
            '(custom-safe-themes
               '("4c7228157ba3a48c288ad8ef83c490b94cb29ef01236205e360c2c4db200bb18" default)))
          (custom-set-faces
            ;; custom-set-faces was added by Custom.
            ;; If you edit it by hand, you could mess it up, so be careful.
            ;; Your init file should contain only one such instance.
            ;; If there is more than one, they won't work right.
            )










          )
