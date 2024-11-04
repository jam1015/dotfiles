(load-relative "elpaca_setup.el") ;; remember elpaca-after-init-hook  and :ensure (:build (+elpaca/build-if-new))
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

(use-package evil
  ;;:after undo-tree
  :init

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


;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/package-folder/"))

(use-package evil-god-toggle
  
  :ensure (:after evil :host github :repo "jam1015/evil-god-toggle" :build (+elpaca/build-if-new))
  :config
  (global-set-key (kbd "C-;") (lambda () (interactive) (god-toggle)))

  ;; Set customization variables using defcustoms
  (customize-set-variable 'evil-god-toggle-persist-visual-to-evil t)
  (customize-set-variable 'evil-god-toggle-persist-visual-to-god t)

  ;; Define Evil key bindings
  (evil-define-key 'god global-map "C-;" (lambda () (interactive) (god-toggle)))
  (evil-define-key 'god global-map [escape] (lambda () (interactive) (evil-stop-execute-in-god-state nil)))

  ;; Set cursor appearance for different states
  (setq evil-god-state-cursor '(box "Red"))
  (setq evil-insert-state-cursor '(bar "Red"))
  (setq evil-visual-state-cursor '(hollow "Red"))
  (setq evil-normal-state-cursor '(box "White"))
  )










(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package xclip
  :config
  (xclip-mode 1))  ; Enable system clipboard support for * and + registers

(use-package nord-theme :demand t)
