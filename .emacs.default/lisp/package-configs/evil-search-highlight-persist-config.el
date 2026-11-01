;;; -*- lexical-binding: t; -*-
(use-package evil-search-highlight-persist
  :vc (:url "https://github.com/jam1015/evil-search-highlight-persist"
       :rev :newest)
  :after (evil evil-leader)
  :config
  (global-evil-search-highlight-persist t)
  (my/mappings-evil-search-highlight-persist))

(provide 'evil-search-highlight-persist-config)
;;; end evil-search-highlight-persist-config.el
