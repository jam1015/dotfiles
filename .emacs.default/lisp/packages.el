(require 'elpaca-setup) ;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
;;(load-relative "straight_setup.el")

(use-package god-mode
  :config
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (setq god-mode-enable-function-key-translation nil)
  (define-key god-local-mode-map (kbd ".") #'repeat))

(use-package undo-tree
  :demand t
  :init
  (global-undo-tree-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-overriding-maps nil)
  (evil-collection-init)
  )

(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl"))  ;; or whatever Lisp you use (e.g., ccl, ecl)

(use-package sly-quicklisp
  :after sly)

(use-package sly-asdf
  :after sly)



(use-package evil
  ;;:after undo-tree
  :init
  (setq evil-want-keybinding nil)

  (with-eval-after-load 'evil
    (evil-define-command evil-quit (&optional force)
      "Close the current window, current frame, current tab. If FORCE is provided, exit Emacs.
If the current frame belongs to some client the client connection
is closed."
      :repeat nil
      (interactive "<!>")
      (condition-case nil
          (evil-window-delete)
        (error
         (if (and (bound-and-true-p server-buffer-clients)
                  (fboundp 'server-edit)
                  (fboundp 'server-buffer-done))
             (if force
                 (server-buffer-done (current-buffer))
               (server-edit))
           (condition-case nil
               (delete-frame)
             (error
              (condition-case nil
                  (tab-bar-close-tab)
                (error
                 (if force
                     (kill-emacs)
                   (message "Not exiting Emacs. Use :q! to force quit.")))))))))

      )

    (evil-define-command evil-save-and-close (file &optional bang)
      "Save the current buffer and close the window. If BANG is provided, force actions."
      :repeat nil
      (interactive "<f><!>")
      (evil-write nil nil nil file bang)
      (evil-quit bang))


    (evil-define-command evil-quit-all (&optional bang)
      "Exit Emacs only if BANG is provided. If BANG is not provided, do nothing."
      :repeat nil
      (interactive "<!>")
      (if bang
	  (let ((proc (frame-parameter (selected-frame) 'client)))
            (if proc
		(with-no-warnings
		  (server-delete-client proc))
              (dolist (process (process-list))
		(set-process-query-on-exit-flag process nil))
              (kill-emacs)))
	(message "Not exiting Emacs. Use :qa! to force quit.")))

    )

  (setq evil-default-state 'normal)
  :custom
  (evil-undo-system 'undo-tree)
  (display-line-numbers-type 'relative)
  :config



  (evil-mode 1)
  (global-display-line-numbers-mode t)
  ;; Initialize savehist-additional-variables if it's void
  (unless (boundp 'savehist-additional-variables)
    (setq savehist-additional-variables nil))
  ;; Append 'evil-ex-history to savehist-additional-variables
  (add-to-list 'savehist-additional-variables 'evil-ex-history)
  ;; Turn on savehist-mode
  (savehist-mode 1)
  )


(add-to-list 'load-path (expand-file-name "~/.emacs.d/package-folder/"))

(use-package restart-emacs
  :init (setq restart-emacs-restore-frames t)
  )

(use-package cursor-contraster
  :ensure (:host github
                 :repo "jam1015/cursor-contraster"
                 :after (evil god-mode)))

(use-package evil-god-toggle
  :ensure (:host github
                 :repo "jam1015/evil-god-toggle"
                 :after (evil god-mode cursor-contraster))
  :init

  :config
  ;;(require 'cursor-contraster)
  ;; 1) Enable the global minor mode (so its keymap + lighter are active)
  (evil-god-toggle-mode 1)

  ;; 2) Core toggle binding in the minor-mode’s keymap
  (define-key evil-god-toggle-mode-map (kbd "C-;")
	      #'evil-god-toggle--god)

  ;; 3) State‑specific bindings in that same map:
  (evil-define-key 'god
    evil-god-toggle-mode-map
    [escape] (lambda () (interactive)
               (evil-god-toggle--stop-choose-state 'normal)))
  (evil-define-key 'god-off
    evil-god-toggle-mode-map
    [escape] (lambda () (interactive)
               (evil-god-toggle--stop-choose-state 'normal)))

  (evil-define-key 'god-off evil-god-toggle-mode-map
    (kbd "<S-escape>") (lambda () (interactive) (evil-god-toggle--bail)))

  (evil-define-key 'normal
    evil-god-toggle-mode-map
    "," #'evil-god-toggle--once)

  ;; 4) Your visual‑persistence and global flag settings
  (setq evil-god-toggle-persist-visual 'always
        evil-god-toggle-global        nil)

  (cursor-contraster-mode 1)
  (cursor-contraster-setup-with-specs
   '((:var evil-god-state-cursor     :shape box    :index 1)
     (:var evil-god-off-state-cursor :shape bar    :index 2)
     (:var evil-insert-state-cursor  :shape bar    :index 3)
     (:var evil-visual-state-cursor  :shape hollow :index 4)
     (:var evil-normal-state-cursor  :shape hollow :index 8)))


  )

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)

  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))


(use-package anisochromatic-theme
  :ensure (:host github :repo "isomatter-labs/anisochromatic-emacs" )
  )

(use-package solarized-theme
  :ensure t
  )

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package xclip
  :config
  (xclip-mode 1))  ; Enable system clipboard support for * and + registers

;;(use-package nord-theme :demand t)

(provide 'packages)
