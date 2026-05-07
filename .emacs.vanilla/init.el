(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'catppuccin-theme)
  (package-refresh-contents)
  (package-install 'catppuccin-theme))

(setq catppuccin-flavor 'mocha)
(load-theme 'catppuccin t)

(setq treesit-extra-load-path
      (list (expand-file-name "~/.emacs.vanilla/tree-sitter/")))

(setq treesit-font-lock-level 4)

;; Workaround: Emacs 30.2 compiles (:match ...) predicates as (#match ...) without
;; the '?' suffix required by tree-sitter 0.26 (ABI15). These predicates fail at
;; query execution time even though they compile successfully. We replace the three
;; affected python-ts-mode features (keyword, builtin, type) with equivalent queries
;; that use function-based fontification instead of (:match ...) predicates.

(defun my-python-builtin-fontify (node override start end)
  (when (and (boundp 'python--treesit-builtins)
             (member (treesit-node-text node t) python--treesit-builtins))
    (treesit-fontify-with-override
     (treesit-node-start node) (treesit-node-end node)
     'font-lock-builtin-face override)))

(defun my-python-special-attr-fontify (node override start end)
  (when (and (boundp 'python--treesit-special-attributes)
             (member (treesit-node-text node t) python--treesit-special-attributes))
    (treesit-fontify-with-override
     (treesit-node-start node) (treesit-node-end node)
     'font-lock-builtin-face override)))

(defun my-python-exception-fontify (node override start end)
  (when (and (boundp 'python--treesit-exceptions)
             (member (treesit-node-text node t) python--treesit-exceptions))
    (treesit-fontify-with-override
     (treesit-node-start node) (treesit-node-end node)
     'font-lock-type-face override)))

(add-hook 'python-ts-mode-hook
          (lambda ()
            (setq-local treesit-font-lock-settings
                        (seq-remove
                         (lambda (s) (memq (nth 2 s) '(keyword builtin type)))
                         treesit-font-lock-settings))

            (setq-local treesit-font-lock-settings
                        (append
                         (treesit-font-lock-rules
                          :language 'python
                          :feature 'keyword
                          `([,@python--treesit-keywords] @font-lock-keyword-face))

                         (treesit-font-lock-rules
                          :language 'python
                          :feature 'builtin
                          '((call function: (identifier) @my-python-builtin-fontify)
                            (attribute attribute: (identifier) @my-python-special-attr-fontify)))

                         (treesit-font-lock-rules
                          :language 'python
                          :feature 'type
                          :override t
                          '((identifier) @my-python-exception-fontify
                            (type [(identifier) (none)] @font-lock-type-face)
                            (type (attribute attribute: (identifier) @font-lock-type-face))
                            (type (_ !attribute [[(identifier) (none)] @font-lock-type-face
                                                 (attribute attribute: (identifier) @font-lock-type-face)]))
                            (type (subscript (attribute attribute: (identifier) @font-lock-type-face)))
                            (type (binary_operator) @python--treesit-fontify-union-types)
                            (class_definition
                             superclasses:
                             (argument_list [(identifier) @font-lock-type-face
                                             (attribute attribute: (identifier) @font-lock-type-face)
                                             (subscript (identifier) @font-lock-type-face)
                                             (subscript (attribute attribute: (identifier) @font-lock-type-face))]))
                            (class_pattern (dotted_name (identifier) @font-lock-type-face :anchor))))

                         treesit-font-lock-settings))

            (treesit-font-lock-recompute-features)))

(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
