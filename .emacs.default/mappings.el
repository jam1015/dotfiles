(defun reload-config ()
  "Reloads the Emacs configuration file."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(require 'package)
