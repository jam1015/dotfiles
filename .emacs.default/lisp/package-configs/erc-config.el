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
;; /join #channel
;; /nick
;; /bye /exit  /quit  [message] ## get out of IRC completely (quit is the real one)
;; /part and /leave  #####     leave the channel
;; /whoami
;; /me ####### at the beginning puts my name
;; /whois [user]
;; /who #channel ###### who is onther
;; /names #channel #### is lighter
;; /msg  user  message ####### one off
;; /msg  #channel  message ####### one off
;; /query user ###### for direct communication
;; /quert      ###### to end
;; /dcc chat [name] ######  asks for a dcc session, they are faster
;; /dcc send [name] /path/to/file   #### send a file
;; /msg =[name] hellow     ######### one off in dcc
;; /help [command]
;; /list ######## list all channels
;; /away [message] ### im away
;; /away   ######    im back (always, message is needed for away)
;; /ping user         ########   these ping, 
;; /ping #channel
;; /CTCP [user/#channe] PING goes directly but often doesn't work
;; end erc-config.el
