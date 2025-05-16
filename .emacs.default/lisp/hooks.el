(require 'cl-lib)  ;; For using 'cl-intersection'

(defun eshell/ff (&rest files)
  "In Eshell, open each FILE in the current Emacs frame."
  (dolist (f files)
    (find-file (expand-file-name f))))
;; Usage in Eshell:  ff foo.txt bar.org

(provide 'hooks)
