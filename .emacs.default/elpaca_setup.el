;;;; Remove straight.el setup
;;(message "Removing Straight")
;;(setq straight-use-package-by-default nil)
;;
;;;; Clean up any variables or settings related to straight.el
;;(setq straight-base-dir nil)
;;(setq straight-repository-branch nil)
;;
;;;; Optional: Delete the straight.el directory if you want to completely remove it
;;(let ((straight-dir (expand-file-name "straight" user-emacs-directory)))
;;  (when (file-exists-p straight-dir)
;;    (delete-directory straight-dir t)))
;;
;;;; Remove any package use defined with straight.el
;;(fmakunbound 'straight-use-package)
;;
;;;; Unload straight.el if it's loaded
;;(when (featurep 'straight)
;;  (unload-feature 'straight t))



(message "Setting up Elpaca")

(defvar elpaca-installer-version 0.8)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  ;; Enable Elpaca support for use-package's :ensure keyword.
  (elpaca-use-package-mode))

(require 'use-package-ensure)
(setq use-package-always-ensure t)



 ;;elpaca-build-functions.el
(defun +elpaca/build-if-new (e)
  (setf (elpaca<-build-steps e)
        (if-let ((default-directory (elpaca<-build-dir e))
                 (main (ignore-errors (elpaca--main-file e)))
                 (compiled (expand-file-name (concat (file-name-base main) ".elc")))
                 ((file-newer-than-file-p main compiled)))
            (progn (elpaca--signal e "Rebuilding due to source changes")
                   (cl-set-difference elpaca-build-steps
                                      '(elpaca--clone elpaca--configure-remotes elpaca--checkout-ref)))
          (elpaca--build-steps nil (file-exists-p (elpaca<-build-dir e))
                               (file-exists-p (elpaca<-repo-dir e)))))
  (elpaca--continue-build e))


(message "Finished setting up elpaca")
