;;; -*- lexical-binding: t; -*-
(use-package package-lint
  ;; Loads the first time you press C-c l in an elisp buffer.
  :defer t
  :init
  (my/mappings-package-lint))
(provide 'package-lint-config)
;;;end package-lint-config.el
