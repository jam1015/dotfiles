(setq inhibit-startup-screen t)
(blink-cursor-mode 0)
(setq visible-bell 1)
(set-frame-font "CMU Typewriter Text-11" t t)
(setq scroll-margin 3)
(setq scroll-conservatively 10000)
;;(load-theme 'nord)
(add-hook 'emacs-startup-hook (lambda () (load-theme 'nord t)))
