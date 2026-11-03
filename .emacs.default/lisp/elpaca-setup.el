;;; -*- lexical-binding: t; -*-

;;;; ============================================================
;;;;  Elpaca bootstrap
;;;; ============================================================
;; Clone progfolio/elpaca if missing, byte-compile it, load it.
;; Verbatim from upstream's installer snippet except for the version
;; defvar at the top.

(message "Setting up Elpaca")
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
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
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;;;; ============================================================
;;;;  elpaca-build-augment
;;;; ============================================================

(elpaca (elpaca-build-augment
				 :host github
				 :repo "jam1015/elpaca-build-augment"
				 :wait t)
	(elpaca-build-augment-enable)
	(require 'elpaca-build-augment-audit)
	;;(setq elpaca-build-augment-audit-watch '(auctex ess eat))
	(elpaca-build-augment-audit-enable)
	)


;;;; ============================================================
;;;;  use-package integration
;;;; ============================================================



(elpaca elpaca-use-package
  ;; Enable Elpaca support for use-package's :ensure keyword.
  (elpaca-use-package-mode))

(require 'use-package-ensure)
(setq use-package-always-ensure t)


;;;; ============================================================
;;;;  Custom build steps
;;;; ============================================================
;; Reusable build-step functions that packages can opt into via
;; `:ensure (:build (... +elpaca/build-step-make ...))'.

  (defun +elpaca/build-if-new (e)
    (setf (elpaca<-build-steps e)
          (if-let* ((default-directory (elpaca<-build-dir e))
                    (main (ignore-errors (elpaca--main-file e)))
                    (compiled (expand-file-name (concat (file-name-base main) ".elc")))
                    ((file-newer-than-file-p main compiled)))
              (progn (elpaca--signal e "Rebuilding due to source changes")
                     (cl-set-difference elpaca-build-steps
                                        '(elpaca--clone elpaca--configure-remotes elpaca--checkout-ref)))
            (elpaca--build-steps nil (file-exists-p (elpaca<-build-dir e))
                                 (file-exists-p (elpaca<-repo-dir e)))))
    (elpaca--continue-build e))



;;;; ============================================================
;;;;  Diagnostics
;;;; ============================================================

(defcustom +elpaca/log-file "/tmp/elpaca.log"
  "Where `+elpaca/dump-logs' writes." :type 'file)

(defun +elpaca/dump-logs ()
  "Dump every queued elpaca's status and build log to `+elpaca/log-file'.
Share that file to diagnose first-run failures when the UI log is
too lossy or already truncated."
  (interactive)
  (with-temp-buffer
    (insert (format ";; Elpaca log dump %s\n;; emacs %s\n\n"
                    (format-time-string "%F %T") emacs-version))
    (pcase-dolist (`(,id . ,e) (elpaca--queued))
      (insert (format "=== %s === status=%s\n" id (elpaca<-status e)))
      (insert (format "    recipe: %S\n" (elpaca<-recipe e)))
      ;; Pull this package's events out of the global log.
      (dolist (ev (nreverse (elpaca-event-log id)))
        (let ((payload (elpaca-event<-payload ev)))
          (insert (format "    [%s] %s %s\n"
                          (format-time-string "%T" (elpaca-event<-time ev))
                          (or (plist-get payload :status)
                              (elpaca-event<-type ev))
                          (or (plist-get payload :info) "")))))
      (insert "\n"))
    (write-region (point-min) (point-max) +elpaca/log-file))
  (message "Elpaca log → %s" +elpaca/log-file))

(defun +elpaca/audit-missing-info ()
  "List elpaca packages that ship .texi sources but have no built .info files.
Flags packages whose manuals are missing from Info."
  (interactive)
  (let (missing)
    (pcase-dolist (`(,id . ,e) (elpaca--queued))
      (let ((repo  (ignore-errors (elpaca<-source-dir e)))
            (build (ignore-errors (elpaca<-build-dir e))))
        (when (and repo (file-directory-p repo))
          (let* ((all-texi (directory-files-recursively repo "\\.texi\\'" nil nil t))
                 ;; Skip test fixtures and sibling-package sources.
                 (doc-texi (cl-remove-if
                            (lambda (f)
                              (string-match-p
                               "/\\(tests?\\|resources?\\|fixtures?\\|examples?\\)/"
                               f))
                            all-texi))
                 (has-info (and build (file-directory-p build)
                                (directory-files-recursively
                                 build "\\.info\\'" nil nil t))))
            (when (and doc-texi (not has-info))
              (push (symbol-name id) missing))))))
    (setq missing (sort (delete-dups missing) #'string<))
    (with-current-buffer (get-buffer-create "*elpaca-missing-info*")
      (erase-buffer)
      (if missing
          (progn
            (insert (format "%d package(s) ship .texi but have no built .info:\n\n"
                            (length missing)))
            (dolist (p missing) (insert "  " p "\n")))
        (insert "All elpaca packages with .texi sources have built .info files.\n"))
      (display-buffer (current-buffer)))
    missing))

(message "Finished setting up elpaca")
(provide 'elpaca-setup)
;;;end elpaca-setup.el
