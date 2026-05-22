(use-package xclip

    :ensure (:host github
                 :repo "jam1015/xclip"
           :build (:sub elpaca--clone +elpaca/build-if-new)
                  :branch "master")

  :config
  (xclip-mode 1))

(provide 'xclip-config)
;;;end xclip-config.el
