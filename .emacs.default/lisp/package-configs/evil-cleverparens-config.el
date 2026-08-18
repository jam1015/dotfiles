(use-package evil-cleverparens
  :hook ((emacs-lisp-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          clojure-mode
          ielm-mode) . evil-cleverparens-mode)
  :config
  ;; Free [ and ] so evil-collection's unimpaired bindings ([b, ]b, ...) work
  ;; in lisp buffers; expose the cleverparens motions behind the evil leader.
  (dolist (state '(normal visual motion))
    (dolist (key '("[" "]" "{" "}"))
      (evil-define-key state evil-cleverparens-mode-map (kbd key) nil)))
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "[" #'evil-cp-previous-opening
      "]" #'evil-cp-next-closing
      "{" #'evil-cp-next-opening
      "}" #'evil-cp-previous-closing)))

(provide 'evil-cleverparens-config)
;;;end evil-cleverparens-config.el
