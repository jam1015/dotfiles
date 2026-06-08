(use-package ess
  :defer t
  :commands (R R-mode ess-mode)
  :init
  (setq ess-style 'RStudio
        ess-eval-visibly 'nowait))

(provide 'ess-config)
;;; end ess-config.el
