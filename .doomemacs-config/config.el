;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jordan Mandel"
	  user-mail-address "jordan.mandel@live.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 9 :weight 'semi-light)
;;	  doom-variable-pitch-font (font-spec :family "Fira Code" :size 8))
;;

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



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



;; In your ~/.doom.d/config.el or ~/.config/doom/config.el


(use-package! evil-god-toggle
  :config
  (evil-god-toggle-mode 1)

  (define-key evil-god-toggle-mode-map (kbd "C-,")
    #'evil-god-toggle--god)

  (evil-define-key 'god
    evil-god-toggle-mode-map
    [escape] (lambda () (interactive)
               (evil-god-toggle--stop-choose-state 'normal)))

  (evil-define-key 'god-off
    evil-god-toggle-mode-map
    [escape] (lambda () (interactive)
               (evil-god-toggle--stop-choose-state 'insert)))

  (evil-define-key 'god-off
    evil-god-toggle-mode-map
    (kbd "<S-escape>") #'evil-god-toggle-bail)

  (evil-define-key 'normal
    evil-god-toggle-mode-map
    "," #'evil-god-toggle--once)

  (setq evil-god-toggle-persist-visual 'always
        evil-god-toggle-global        nil)

  (setq evil-god-state-cursor       '(box    "Red")
        evil-god-off-state-cursor   '(bar    "Green")
        evil-insert-state-cursor    '(bar    "Red")
        evil-visual-state-cursor    '(hollow "Red")
        evil-normal-state-cursor    '(hollow "Black"))
  )
