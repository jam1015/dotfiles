(use-package which-key
  :ensure nil
  :init
(setq
   ;;which-key-allow-evil-operator;s t
   ;;which-key-show-operator-state-maps t
   which-key-idle-delay 0.2
   which-key-idle-secondary-delay 0.05
   which-key-popup-type 'side-window
   which-key-side-window-location 'bottom
   which-key-side-window-max-height 0.25
   which-key-sort-order 'which-key-prefix-then-key-order
   which-key-sort-uppercase-first nil
   which-key-separator " → "
   which-key-prefix-prefix "+ ")
  :config
  (which-key-mode 1)
  (which-key-enable-god-mode-support)
  )


(provide 'which-key-config)
