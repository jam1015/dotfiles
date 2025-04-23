;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
;; ~/.doom.d/packages.el
(package! undo-tree)
(package! god-mode)


;;(package! evil-god-toggle :recipe 
;;  :recipe (:host github
;;                 :repo "jam1015/evil-god-toggle"
;;                 :after (god-mode))
;;)
;;
;;(use-package! evil-god-toggle
;;  :config
;;  ;; 1) Enable the global minor mode (so its keymap + lighter are active)
;;  (evil-god-toggle-mode 1)
;;
;;  ;; 2) Core toggle binding in the minor-mode’s keymap
;;  (define-key evil-god-toggle-mode-map (kbd "C-;")
;;    #'evil-god-toggle--god)
;;
;;  ;; 3) Bind escape from god mode to take you to evil normal mode
;;  (evil-define-key 'god
;;    evil-god-toggle-mode-map
;;    [escape] (lambda () (interactive)
;;               (evil-god-toggle--stop-choose-state 'normal)))
;;
;;  ;; 4) Bind escape from god-off mode to take you to evil insert mode
;;  (evil-define-key 'god-off
;;    evil-god-toggle-mode-map
;;    [escape] (lambda () (interactive)
;;               (evil-god-toggle--stop-choose-state 'insert)))
;;
;;  ;; 5) Bind  shift+escape to bail from god-off-mode 
;;  (evil-define-key 'god-off
;;    evil-god-toggle-mode-map
;;    (kbd "<S-escape>") #'evil-god-toggle-bail)
;;
;;  ;; 6) bind comma in  evil normal mode to initiate a once-off god mode command
;;  (evil-define-key 'normal
;;    evil-god-toggle-mode-map
;;    "," #'evil-god-toggle--once)
;;
;;  ;; 7) Your visual‑persistence and global flag settings
;;  (setq evil-god-toggle-persist-visual 'always
;;        evil-god-toggle-global        nil)
;;
;;  ;; 8) Optional: customize your cursors per state
;;  (setq evil-god-state-cursor       '(box    "Red")
;;        evil-god-off-state-cursor   '(bar    "Green")
;;        evil-insert-state-cursor    '(bar    "Red")
;;        evil-visual-state-cursor    '(hollow "Red")
;;        evil-normal-state-cursor    '(hollow "Black"))
;;  )
;;
;;(package! nerd-icons)
;;
