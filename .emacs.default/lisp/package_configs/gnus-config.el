(use-package gnus
  :defer t
  :ensure nil
  :init
  (setq user-full-name "Jordan Mandel"
        user-mail-address "jordan.mandel@live.com"
        gnus-select-method
        '(nntp "news.eternal-september.org"
               (nntp-authinfo-file "~/.authinfo")
               (nntp-open-connection-function nntp-open-tls-stream)
               (nntp-port-number 563))
        gnus-read-active-file 'some
        gnus-use-cache t))

(provide 'gnus-config)
;;;end gnus-config.el
