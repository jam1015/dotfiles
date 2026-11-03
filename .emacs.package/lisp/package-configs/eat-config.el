;;; eat-config.el --- Emulate A Terminal (eat) configuration -*- lexical-binding: t; -*-

;; `eat-eshell-mode' is a global minor mode that lets eshell run full-screen
;; TUI programs (vim, htop, less, top, etc.) by intercepting eshell's visual
;; command machinery and rendering them in an eat terminal inside the eshell
;; buffer. It does NOT mutate `eshell-visual-commands' -- it hooks
;; `eshell-exec-visual' directly -- so it does not conflict with any existing
;; visual-command configuration.
;;
;; Ordering: we attach to `eshell-load-hook' (eat's recommended entry point) so
;; eat-eshell-mode is enabled the moment eshell first loads, before any
;; buffer-local `eshell-mode-hook' runs. We also call it in :config to cover
;; the race where an eshell buffer is created (e.g. via `server-after-make-frame'
;; opening eshell at frame creation) before elpaca has activated this package;
;; the mode is idempotent.

(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode)
  :config
  (eat-eshell-mode 1))

(provide 'eat-config)
;;; end eat-config.el
