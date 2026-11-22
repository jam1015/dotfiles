;;; -*- lexical-binding: t; -*-
(use-package which-key
  :ensure nil
  :init
(setq
   ;;which-key-allow-evil-operator;s t
   ;;which-key-show-operator-state-maps t
   which-key-idle-delay 0.2
   which-key-idle-secondary-delay 0.05
   which-key-popup-type 'side-window
   which-key-side-window-location 'bottom
   which-key-side-window-max-height 0.25
   which-key-sort-order 'which-key-prefix-then-key-order
   which-key-sort-uppercase-first nil
   which-key-separator " → "
   which-key-prefix-prefix "+ ")
  :config
  (which-key-mode 1)
  (which-key-enable-god-mode-support)
  )


;;; ============================================================
;;; PREFIX LABELS
;;; ============================================================
;; Central place to name "prefix" cells that which-key would otherwise
;; show bare. Add one line per prefix as you encounter it.
;;
;; APIs:
;;   (which-key-add-keymap-based-replacements MAP "KEY" "LABEL" ...)
;;   (which-key-add-key-based-replacements   "KEY" "LABEL" ...)
;;
;; Discovery:
;;   M-x which-key-show-top-level
;;   M-x which-key-show-full-keymap
;;   M-x which-key-show-major-mode

(with-eval-after-load 'which-key

  ;; ---------- Global prefixes (built-in) ----------
  (which-key-add-key-based-replacements
    "C-x 4"   "+other-window"
    "C-x 5"   "+other-frame"
    "C-x t"   "+tab-bar"
    "C-x r"   "+register/rect"
    "C-x n"   "+narrow"
    "C-x a"   "+abbrev"
    "C-x w"   "+window"
    "C-x x"   "+buffer"
    "C-x p"   "+project"
    "C-x C-k" "+kmacro"
    "C-x RET" "+coding-system"
    "C-h 4"   "+help-other-window"
    "M-g"     "+goto"
    "M-s"     "+search"
    "C-c @"   "+outline")

  ;; ---------- evil / evil-collection ----------
  (which-key-add-key-based-replacements
    "g"  "+goto"
    "z"  "+fold/scroll"
    "["  "+prev"
    "]"  "+next"
    "% " "+mark-pct")

  ;; ---------- evil-leader (SPC) ----------
  (with-eval-after-load 'evil-leader
    (which-key-add-keymap-based-replacements evil-leader--default-map
      "b"   "+buffer"
      "e"   "+eshell"
      "n"   "+search"
      "SPC" "+eval"
      "d"   "+lsp-diagnostics"
      "l"   "+lsp"
      "lw"  "+lsp-workspace"
      "lt"  "+lsp-toggles"))

  ;; ---------- AUCTeX ----------
  (with-eval-after-load 'tex
    (which-key-add-keymap-based-replacements TeX-mode-map
      "C-c C-o" "+outline/fold"
      "C-c C-p" "+preview"
      "C-c C-t" "+toggle"
      "C-c C-q" "+fill"))

  ;; ---------- dired ----------
  (with-eval-after-load 'dired
    (which-key-add-keymap-based-replacements dired-mode-map
      "%"   "+regex"
      "*"   "+mark"
      ":"   "+epa"
      "C-t" "+image"))

  ;; ---------- magit ----------
  ;; magit uses transient — most prefixes are self-labeled. Add here only
  ;; if a non-transient prefix shows as bare.

  ;; ---------- consult / embark ----------
  ;; Both bind leaf commands, not prefixes, by default. Add if you build
  ;; your own prefix maps on top.

  ;; ---------- AUCTeX / LaTeX ----------
  (with-eval-after-load 'latex
    (which-key-add-keymap-based-replacements LaTeX-mode-map
      "C-c C-p" "+preview"
      "C-c C-q" "+fill"))

  ;; ---------- flycheck ----------
  (with-eval-after-load 'flycheck
    (which-key-add-keymap-based-replacements flycheck-mode-map
      "C-c !" "+flycheck"))

  ;; ---------- markdown ----------
  (with-eval-after-load 'markdown-mode
    (which-key-add-keymap-based-replacements markdown-mode-map
      "C-c C-a" "+links"
      "C-c C-c" "+commands"
      "C-c C-s" "+style"
      "C-c C-t" "+headings"
      "C-c C-x" "+toggle"))

  ;; ---------- ess / R ----------
  (with-eval-after-load 'ess-mode
    (which-key-add-keymap-based-replacements ess-mode-map
      "C-c C-e" "+eval-ext"))

  ;; ---------- geiser ----------
  (with-eval-after-load 'geiser-mode
    (which-key-add-keymap-based-replacements geiser-mode-map
      "C-c C-d" "+docs"
      "C-c C-e" "+eval-ext"
      "C-c RET" "+macroexpand"))
  (with-eval-after-load 'geiser-repl
    (which-key-add-keymap-based-replacements geiser-repl-mode-map
      "C-c C-d" "+connection"
      "C-c C-e" "+eval-ext"))

  ;; ---------- sly ----------
  (with-eval-after-load 'sly
    (which-key-add-keymap-based-replacements sly-mode-map
      "C-c C-d" "+docs"
      "C-c C-w" "+who"
      "C-c C-x" "+extras"))

  ;; ---------- pdf-tools ----------
  (with-eval-after-load 'pdf-view
    (which-key-add-keymap-based-replacements pdf-view-mode-map
      "s"       "+slice/size"
      "i"       "+annotations"
      "C-c C-r" "+revert/redraw"))

  ;; ---------- gnus ----------
  (with-eval-after-load 'gnus-group
    (which-key-add-keymap-based-replacements gnus-group-mode-map
      "A" "+list-groups"
      "G" "+group"
      "H" "+help"
      "M" "+mark"
      "S" "+subscribe"
      "W" "+web"))

  (with-eval-after-load 'gnus-sum
    (which-key-add-keymap-based-replacements gnus-summary-mode-map
      "A" "+articles-nav"
      "B" "+backend"
      "G" "+group"
      "M" "+mark"
      "S" "+send"
      "T" "+threads"
      "W" "+wash"
      "X" "+uudecode"))

  ;; ---------- embark ----------
  (with-eval-after-load 'embark
    (which-key-add-keymap-based-replacements embark-general-map
      "C" "+collect/export"))

  ;; ---------- undo-tree ----------
  (with-eval-after-load 'undo-tree
    (which-key-add-keymap-based-replacements undo-tree-map
      "C-x" "+undo-tree"))

  ;; ---------- erc / org ----------
  ;; Discover with `which-key-show-major-mode' in the relevant buffer and
  ;; add entries as needed.

  ) ;; end with-eval-after-load 'which-key


(provide 'which-key-config)
;;;end which-key-config.el
