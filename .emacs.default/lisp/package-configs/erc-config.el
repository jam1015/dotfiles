(use-package erc
  :ensure nil
  :custom
  (erc-join-buffer 'switch-to-buffer)
  (erc-user-full-name "Jordan Mandel")
  ;; (erc-hide-list '("JOIN" "PART" "QUIT"))
  ;; (erc-fill-column 80)
  ;; (erc-timestamp-only-if-changed-flag nil)
  ;; (erc-timestamp-format "[%H:%M] ")
  ;; (erc-autojoin-channels-alist '(("Libera.Chat" "#libera" "#test")))
  ;; (erc-modules '(autojoin button completion fill irccontrols list match
  ;;                move-to-prompt netsplit networks noncommands readonly
  ;;                ring stamp track)))
  :config
  (defun irc-libera ()
    (interactive)
    ;;identify via /msg NickServ IDENTIFY badamkulfi <password>
    (erc-tls :server "irc.libera.chat" :port 6697 :nick "badamkulfi")))

(use-package erc-sasl
  :ensure nil
  :after erc
  :custom
  (erc-sasl-mechanism 'scram-sha-256)
  (erc-sasl-server "irc.libera.chat"))

(provide 'erc-config)
;; /quit -- get out of IRC completely
;; /part and /leave       leave the channel
;; /whois /whoami /who
;; end erc-config.el
