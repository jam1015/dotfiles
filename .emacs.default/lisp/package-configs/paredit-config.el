(use-package paredit
  :hook ((emacs-lisp-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          clojure-mode
          eval-expression-minibuffer-setup
          ielm-mode) . enable-paredit-mode))

;; In the M-: (eval-expression) minibuffer, paredit binds RET to
;; `paredit-RET' (newline), not submit. Paredit is a minor-mode map, so
;; it outranks a buffer-local binding — override it via
;; `minor-mode-overriding-map-alist'. C-j still runs the paredit newline.
;;
;; Registered outside `:config' so it's in place before the first M-:
;; (use-package defers paredit's load, and `:config' would only run
;; *after* the first hook invocation, missing it).
(defun my/paredit-eval-expression-minibuffer-setup ()
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'exit-minibuffer)
    (define-key map [return]    #'exit-minibuffer)
    (push (cons 'paredit-mode map) minor-mode-overriding-map-alist)))

(add-hook 'eval-expression-minibuffer-setup-hook
          #'my/paredit-eval-expression-minibuffer-setup)

(provide 'paredit-config)
;;;end markdown-mode-config.el
