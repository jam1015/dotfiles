;; Override the codeberg-hosted menu recipe for the popon transitive dep.
;; To revert, comment out this whole use-package form.
(use-package popon
  :ensure
  (popon
   :host github :repo "JasZhe/emacs-popon-mirror"
   :files ("*" (:exclude ".git"))))

(use-package corfu-terminal
  ;; To revert to the codeberg menu recipe, comment the :ensure (...) lines
  ;; below and uncomment `:ensure t'.
  ;; :ensure t
  :ensure
  (corfu-terminal
   :host github :repo "cimisc/emacs-corfu-terminal"
   :files ("*" (:exclude ".git")))
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode +1)
  (advice-add 'corfu--popup-show :before-while
              (lambda (pos &rest _) (not (null pos)))))

(provide 'corfu-terminal-config)
;;; end corfu terminal config
