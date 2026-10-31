;;; -*- lexical-binding: t; -*-
;;;  begin evil-search-hightlihgt-config
(use-package evil-search-highlight-persist
  :ensure (:host github :repo "jam1015/evil-search-highlight-persist")
  :after (evil evil-leader)
  :config
  (global-evil-search-highlight-persist t)
  (my/mappings-evil-search-highlight-persist)

  )

(provide 'evil-search-highlight-persist-config)
;;; end evil-search-hightlihgt-config
