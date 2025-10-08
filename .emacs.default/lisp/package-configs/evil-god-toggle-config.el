(use-package evil-god-toggle
  :ensure (:host github
           :repo "jam1015/evil-god-toggle"
           :build (+elpaca/build-if-new))
  :after (evil god-mode cursor-contraster which-key)
  :init
  
  :config
  ;; 1) Enable the global minor mode (so its keymap + lighter are active)
  (evil-god-toggle-mode 1)

  ;; 2) Enter persistent god mode from Normal/Insert/God-off states with C-;
  (evil-define-key '(normal insert )
    evil-god-toggle-mode-map
    (kbd "C-;") (lambda ()
                  (interactive)
                  (evil-god-toggle-execute-in-god-state t
                                                        )))


  (evil-define-key '(god-off visual)
    evil-god-toggle-mode-map
    (kbd "C-;") (lambda ()
                  (interactive)
                  (evil-god-toggle-execute-in-god-state)))

  ;; 3) Exit god mode to god-off state with C-; 
  (evil-define-key 'god
    evil-god-toggle-mode-map
    (kbd "C-;") (lambda ()
                  (interactive)
                  (evil-god-toggle-execute-in-god-off-state)))

  ;; 4) Escape from any god state returns to Normal
  (evil-define-key '(god god-off god-once)
    evil-god-toggle-mode-map
    [escape] (lambda ()
               (interactive)
               (evil-god-toggle-stop-god-state-maybe-visual 'normal)))

  ;; 5) One-shot God mode: C-, in Normal for exactly one command
  (evil-define-key 'normal
    evil-god-toggle-mode-map
    (kbd "C-,") (lambda ()
                  (interactive)
                  (evil-god-toggle-once t)))


  (evil-define-key 'visual
    evil-god-toggle-mode-map
    (kbd "C-,") (lambda ()
                  (interactive)
                  (evil-god-toggle-once )))
  ;; 6) Visual persistence and global flag settings
  (setq evil-god-toggle-persist-visual 'always))

(provide 'evil-god-toggle-config)
;;;end evil-god-toggle-config.el
