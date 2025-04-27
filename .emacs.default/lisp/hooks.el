(require 'cl-lib)  ;; For using 'cl-intersection'

;; List of shell process names
(defvar shell-process-names
  '("bash" "zsh" "fish" "sh" "ksh" "tcsh" "csh" "dash" "ash" "elvish" "ion")
  "List of shell process names to detect terminal launch.")

;; Function to get the command name of a process by PID
(defun get-process-name-by-pid (pid)
  "Get the command name of the process with PID."
  (string-trim
   (shell-command-to-string
    (format "ps -o comm= -p %d" pid))))

;; Function to get parent process names up to a maximum depth
(defun get-parent-process-names (&optional max-depth)
  "Return a list of process names in the parent chain up to MAX-DEPTH."
  (let ((names '())
        (pid (emacs-pid))
        (depth 0)
        (max-depth (or max-depth 5)))  ;; Limit the depth to prevent infinite loops
    (while (and (> pid 1) (< depth max-depth))
      (let* ((ppid (string-to-number
                    (string-trim
                     (shell-command-to-string
                      (format "ps -o ppid= -p %d" pid)))))
             (process-name (get-process-name-by-pid ppid)))
        (push process-name names)
        (setq pid ppid)
        (setq depth (1+ depth))))
    names))

;; Function to check if Emacs was launched from a terminal shell
(defun launched-from-terminal-p ()
  "Return t if Emacs was launched from a terminal shell."
  (let ((parent-processes (get-parent-process-names)))
    (cl-intersection parent-processes shell-process-names :test #'string=)))

;; Save the current working directory when Emacs exits
(defun save-default-directory ()
  "Save the current `default-directory` to a file."
  (with-temp-file (expand-file-name "last-directory" user-emacs-directory)
    (insert default-directory)))

(add-hook 'kill-emacs-hook #'save-default-directory)

;; Conditionally load the saved working directory
(defun load-default-directory-if-not-launched-from-terminal ()
  "Load the saved `default-directory` unless Emacs was launched from a terminal shell."
  (unless (launched-from-terminal-p)
    (let ((last-dir-file (expand-file-name "last-directory" user-emacs-directory)))
      (when (file-exists-p last-dir-file)
        (let ((dir (with-temp-buffer
                     (insert-file-contents last-dir-file)
                     (buffer-string))))
          (when (file-directory-p dir)
            (setq default-directory dir)))))))

(add-hook 'emacs-startup-hook #'load-default-directory-if-not-launched-from-terminal)
(provide 'hooks)
