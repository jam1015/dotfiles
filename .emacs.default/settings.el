(setq inhibit-startup-screen t)
(blink-cursor-mode 0)
(setq visible-bell 1)
(set-frame-font "InputMonoNerdFont-8" t t)
(setq scroll-margin 3)
(setq scroll-conservatively 10000)
(save-place-mode 1)
;;(load-theme 'nord)
;;(add-hook 'window-setup-hook (lambda () (load-theme 'nord t)))
;;(load-theme 'nord t)
(add-hook 'elpaca-after-init-hook
(lambda () (load-theme 'solarized-light t))
)


(setq debug-on-error t)


