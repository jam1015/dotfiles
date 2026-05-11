(use-package treesit-auto
  :demand t
  :config
  (add-to-list 'treesit-language-source-alist
    '(php "https://github.com/tree-sitter/tree-sitter-php" "master" "php/src"))
  (add-to-list 'treesit-language-source-alist
    '(elixir "https://github.com/elixir-lang/tree-sitter-elixir"))
  (add-to-list 'treesit-language-source-alist
    '(heex "https://github.com/phoenixframework/tree-sitter-heex"))
  (setq treesit-auto-install t)
  (setq treesit-font-lock-level 4)
  (global-treesit-auto-mode)

  ;; --------------------------------------------------------------------------
  ;; Generic fix for Emacs 30.x + tree-sitter 0.26 (ABI15) predicate mismatch.
  ;; Fixed upstream in Emacs 31 (commit b0143530 / bug#79687); no-op there.
  ;;
  ;; Emacs 30.2 compiles (:match REGEX @CAP) as (#match REGEX @CAP) and
  ;; (:pred FN @CAP) as (#pred FN @CAP) — both without the '?' suffix.
  ;; Tree-sitter 0.26 classifies predicates without '?' as "setting" predicates
  ;; rather than "filter" predicates, causing runtime treesit-query-error on
  ;; any feature that uses :match or :pred, even though compilation succeeds.
  ;;
  ;; This advice intercepts treesit-query-compile before the C layer sees the
  ;; pattern. For each broken predicate, it generates an Elisp wrapper function
  ;; that performs the predicate check natively and applies the fontification.
  ;; The original capture is replaced with @WRAPPER-FN, and the predicate is
  ;; removed. Non-face, non-function captures drop the predicate and retain the
  ;; capture (over-matching is safe there).
  ;;
  ;; Result: all :match- and :pred-affected features fully restored for all
  ;; languages without any language-specific code.
  ;; --------------------------------------------------------------------------
(when (= emacs-major-version 30)
  (defvar my-ts--gen-counter 0
    "Counter for unique treesit fontification wrapper function names.")

  (defun my-ts--make-wrapper (pred-check cap-sym)
    "Generate and intern a wrapper function for a broken treesit predicate.
PRED-CHECK is a unary predicate (node -> bool).
CAP-SYM is the capture symbol (with leading @).
Returns the new capture symbol @WRAPPER-FN, or nil if CAP-SYM is unhandled."
    (let* ((cap-str  (symbol-name cap-sym))
           (inner    (and (string-prefix-p "@" cap-str)
                          (intern (substring cap-str 1))))
           (is-face  (and inner (facep inner)))
           (is-fn    (and inner (fboundp inner) (not is-face))))
      (when (or is-face is-fn)
        (let* ((n      (setq my-ts--gen-counter (1+ my-ts--gen-counter)))
               (fn-sym (intern (format "my-ts--fn-%d" n)))
               (check  pred-check)
               (face   (and is-face inner))
               (fn     (and is-fn inner)))
          (fset fn-sym
                (if is-face
                    (let ((f face))
                      (lambda (node override start end)
                        (when (funcall check node)
                          (treesit-fontify-with-override
                           (treesit-node-start node) (treesit-node-end node)
                           f override))))
                  (let ((g fn))
                    (lambda (node override start end)
                      (when (funcall check node)
                        (funcall g node override start end))))))
          (intern (format "@%s" fn-sym))))))

  (defun my-ts--transform-query-sexp (sexp)
    "Transform (:match REGEX @CAP) and (:pred FN @CAP) predicates in SEXP.
Walks SEXP recursively. When a list directly contains broken predicates,
each is replaced with a generated Elisp wrapper function capture."
    (cond
     ((null sexp) nil)
     ((vectorp sexp)
      (apply #'vector (mapcar #'my-ts--transform-query-sexp sexp)))
     ((not (listp sexp)) sexp)
     (t
      (let* ((broken-p  (lambda (x)
                          (and (listp x) (memq (car x) '(:match :pred)))))
             (preds     (seq-filter broken-p sexp))
             (rest      (seq-remove broken-p sexp)))
        (if (null preds)
            (mapcar #'my-ts--transform-query-sexp sexp)
          (let ((result (mapcar #'my-ts--transform-query-sexp rest)))
            (dolist (pred preds)
              (let* ((kind    (car pred))
                     (cap-sym (pcase kind
                                (:match (nth 2 pred))
                                (:pred  (nth 2 pred))))
                     (check   (pcase kind
                                (:match
                                 (let ((re (let ((r (nth 1 pred)))
                                             (if (stringp r) r (format "%s" r)))))
                                   (lambda (node)
                                     (string-match-p re (treesit-node-text node t)))))
                                (:pred
                                 (let ((fn (nth 1 pred)))
                                   (lambda (node) (funcall fn node))))))
                     (new-cap (my-ts--make-wrapper check cap-sym)))
                (when new-cap
                  (setq result
                        (mapcar (lambda (x) (if (eq x cap-sym) new-cap x))
                                result)))))
            result))))))

  
    (define-advice treesit-query-compile
        (:around (orig lang query &optional eager) my-ts-fix-match-predicates)
      (funcall orig lang
               (if (listp query)
                   (my-ts--transform-query-sexp query)
                 query)
               eager))))

(provide 'treesit-auto-config)

;;; end treesit-auto-config.el
