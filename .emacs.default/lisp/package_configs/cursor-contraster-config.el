(use-package cursor-contraster
  :ensure (:host github
                 :repo "jam1015/cursor-contraster"
                 )
  :after (evil god-mode)
  :config
(cursor-contraster-mode 1)
(cursor-contraster-setup-with-specs
 '((:var evil-god-state-cursor     :shape box    :index 0)
   (:var evil-god-off-state-cursor :shape bar    :index 1)
   (:var evil-insert-state-cursor  :shape bar    :index 2)
   (:var evil-visual-state-cursor  :shape hollow :index 3)
   (:var evil-normal-state-cursor  :shape hollow :index 4)))
)

(provide 'cursor-contraster-config)
;;;end cursor-contraster-config.el
