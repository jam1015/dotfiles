;; ;;in init.el, before any `require` calls:
;; Add lisp directory and all its subdirectories to load-path
(let ((default-directory (expand-file-name "lisp" user-emacs-directory)))
  (add-to-list 'load-path default-directory)
  (normal-top-level-add-subdirs-to-load-path))

;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
(require 'elpaca-setup)
(require 'emacs-config)
(require 'package-mappings)
(require 'eshell-config)
(require 'dired-config)

;;(load-relative "straight_setup.el")
(require 'compat-config)

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
(require 'evil-search-highlight-persist-config)
(require 'evil-surround-config)
(require 'evil-overrides)

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
(require 'paredit-config)

;;; lisp
(require 'sly-config)
;;(require 'slime-config)
(require 'lisp-extra-font-lock-config)
(require 'lisp-semantic-hl-config)
;;(require 'rainbow-delimiters-config)
;;(require 'sly-quicklisp-config)
;;(require 'sly-asdf-config)
(require 'geiser-mit-config)
;
;;;; convenience
(require 'which-key-config)
(require 'undo-tree-config)
(require 'xclip-config)
(require 'wgrep-config)

;;; themes
(require 'treesit-auto-config)
(require 'anisochromatic-theme-config)
(require 'solarized-theme-config)
(require 'doom-themes-config)
(require 'all-the-icons-config)


;;; utilities
(require 'perspective-config)
(require 'eat-config)
(require 'dirvish-config)
(require 'gnus-config)
(require 'erc-config)
(require 'dashboard-config)
(require 'kkp-config)


;;; other filetypes
(require 'markdown-mode-config)
(require 'ess-config)
(require 'r-ts-mode-config)

;;;end init.el
