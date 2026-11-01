;;; -*- lexical-binding: t; -*-
(use-package evil-god-toggle
  :vc (:url "https://github.com/jam1015/evil-god-toggle"
       :branch "main"
       :rev :newest)
  :after (evil god-mode cursor-contraster which-key)
  :init
  
  :config
  (evil-god-toggle-mode 1)
  (setopt evil-god-toggle-persist-visual 'always
          evil-god-toggle-persist-visual-once 'to-god)
  (setopt evil-god-toggle-target-state-alist
          '((visual . normal)))
  (my/mappings-evil-god-toggle))

(provide 'evil-god-toggle-config)
;;;end evil-god-toggle-config.el
