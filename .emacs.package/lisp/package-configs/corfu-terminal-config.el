;;; -*- lexical-binding: t; -*-
;; Override the codeberg-hosted menu recipe for the popon transitive dep.
;; To revert, comment out this whole use-package form.
(use-package popon
  :vc (:url "https://github.com/JasZhe/emacs-popon-mirror"
       :rev :newest))

(use-package corfu-terminal
  :vc (:url "https://github.com/cimisc/emacs-corfu-terminal"
       :rev :newest)
  :if (and (not (display-graphic-p))
           (< emacs-major-version 31))
  :config
  (corfu-terminal-mode +1)
  (advice-add 'corfu--popup-show :before-while
              (lambda (pos &rest _) (not (null pos)))))

(provide 'corfu-terminal-config)
;;; end corfu terminal config
