;;(setq debug-on-error t)
(setq package-enable-at-startup nil)
(menu-bar-mode -1)
(tool-bar-mode -1)
(defun my/setup-frame-font (frame)
  (when (display-graphic-p frame)
    (set-frame-font "Lilex Nerd Font Mono-10" t (list frame))))

(add-hook 'after-make-frame-functions #'my/setup-frame-font)
(when (display-graphic-p)
  (set-frame-font "Lilex Nerd Font Mono-10" t t))
(scroll-bar-mode -1)
;;;end early-init.el
