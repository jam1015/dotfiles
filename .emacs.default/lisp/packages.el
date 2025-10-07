(require 'elpaca-setup) ;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
;;(load-relative "straight_setup.el")

;;; evil
(require 'evil-config)
(require 'evil-god-toggle-config)
(require 'evil-anzu-config)
(require 'anzu-config)
(require 'evil-goggles-config)
(require 'evil-collection-config)
(require 'cursor-contraster-config)
(require 'god-mode-config)
(require 'evil-textobj-entire-config)
(require 'evil-leader-config)

;;; elisp
(require 'flycheck-config)
(require 'package-lint-config)
(require 'elisp-lint-config)

;;; completion
(require 'orderless-config)
(require 'marginalia-config)
(require 'consult-config)
(require 'embark-config)
(require 'embark-consult-config)
(require 'cape-config)
(require 'dabbrev-config)
(require 'vertico-config)
(require 'corfu-config)
(require 'corfu-terminal-config)

;;; lisp
(require 'sly-config)
(require 'sly-quicklisp-config)
(require 'sly-asdf-config)
(require 'geiser-mit-config)

;;; convenience
(require 'which-key-config)
(require 'undo-tree-config)
(require 'xclip-config)
(require 'wgrep-config)

;;; themes
(require 'anisochromatic-theme-config)
(require 'solarized-theme-config)


;;; utilities
(require 'dirvish-config)
(require 'gnus-config)
(require 'dashboard-config)


;;; other filetypes
(require 'markdown-mode-config)

(provide 'packages)
;;;end packages.el
