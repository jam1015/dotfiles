;;; slime-eat-config.el --- vim-slime style sends to eat terminals -*- lexical-binding: t; -*-

(use-package slime-eat
  :vc (:url "https://github.com/jam1015/slime-eat"
       :branch "master"
       :rev :newest)
  :after (eat evil)
  :custom
  (slime-eat-modes '(python-mode python-ts-mode
                     ess-r-mode R-mode ess-mode r-ts-mode
                     sh-mode bash-ts-mode))
  :config
  (slime-eat-refresh-hooks)
  (my/mappings-slime-eat))

(provide 'slime-eat-config)
;;; slime-eat-config.el ends here
