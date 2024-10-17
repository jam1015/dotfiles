(defun reload-config ()
  "Reloads the Emacs configuration file."
  (interactive)
  (load-file "~/.emacs.default/init.el"))


(evil-define-command evil-quit (&optional force)
  "Close the current window, current frame, current tab, Emacs.
If the current frame belongs to some client the client connection
is closed."
  :repeat nil
  (interactive "<!>")
  (condition-case nil
      (delete-window)
    (error
     (if (and (bound-and-true-p server-buffer-clients)
              (fboundp 'server-edit)
              (fboundp 'server-buffer-done))
         (if force
             (server-buffer-done (current-buffer))
           (server-edit))
       (condition-case nil
           (delete-frame)
         (error
          (condition-case nil
              (tab-bar-close-tab)
            (error
             (if force (if force
                 (kill-emacs)
               (save-buffers-kill-emacs)))))))))))


)
