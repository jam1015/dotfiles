;;; evil-overrides.el --- Buffer-local evil key overrides + REPL operator -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Declarative buffer-local evil key overrides via mode hooks (buffer-local
;; bindings win over mode-map bindings, so this reclaims keys that
;; evil-collection grabs in mode-specific maps).
;;
;; Also defines `gz' as an evil operator that sends a motion/region to the
;; REPL appropriate for the current major mode.  Example: `gzz' sends the
;; current line, `gzap' a paragraph, `gzip' the inner paragraph.

;;; Code:

(require 'evil)
(require 'cl-lib)

(defvar evil-overrides--specs nil
  "Internal list of registered (mode state key def) specs.")

(defun evil-overrides-register (specs)
  "Register buffer-local evil key overrides.
SPECS is a list of (MODE STATE KEY DEF).  For each entry a hook is added
to MODE-hook that sets a buffer-local binding via `evil-define-key'."
  (dolist (spec specs)
    (cl-destructuring-bind (mode state key def) spec
      (let ((hook (intern (concat (symbol-name mode) "-hook"))))
        (add-hook hook
                  (lambda ()
                    (evil-define-key state 'local (kbd key) def))))
      (push spec evil-overrides--specs))))

(defun evil-overrides-send-region-to-repl (beg end)
  "Send region BEG to END to the appropriate REPL based on major mode."
  (cond
   ((derived-mode-p 'scheme-mode 'geiser-repl-mode)
    (geiser-eval-region beg end))
   ((derived-mode-p 'emacs-lisp-mode)
    (eval-region beg end t))
   ((and (derived-mode-p 'lisp-mode) (bound-and-true-p sly-mode))
    (sly-eval-region beg end))
   ((and (derived-mode-p 'lisp-mode) (bound-and-true-p slime-mode))
    (slime-eval-region beg end))
   ((derived-mode-p 'python-mode)
    (python-shell-send-region beg end))
   (t (user-error "No REPL configured for %s" major-mode))))

(evil-define-operator evil-overrides-send-to-repl (beg end)
  "Send motion/region to REPL.  `gzz' sends current line, `gzap' a paragraph."
  :move-point nil
  (evil-overrides-send-region-to-repl beg end))

(evil-overrides-register
 '((sly-mode        normal "gz" evil-overrides-send-to-repl)
   (slime-mode      normal "gz" evil-overrides-send-to-repl)
   (geiser-mode     normal "gz" evil-overrides-send-to-repl)
   (scheme-mode     normal "gz" evil-overrides-send-to-repl)
   (emacs-lisp-mode normal "gz" evil-overrides-send-to-repl)
   (python-mode     normal "gz" evil-overrides-send-to-repl)))

(provide 'evil-overrides)
;;; evil-overrides.el ends here
