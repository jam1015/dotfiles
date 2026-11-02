;;; -*- lexical-binding: t; -*-

;;;; ============================================================
;;;; 1. Elpaca bootstrap
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
;;;; 2. use-package integration
;;;; ============================================================

(elpaca elpaca-use-package
  ;; Enable Elpaca support for use-package's :ensure keyword.
  (elpaca-use-package-mode))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;;;; ============================================================
;;;; 3. GNU-ELPA mirror redirect (for prebuilt .info)
;;;; ============================================================
;; GNU-ELPA packages like auctex and ess need their `make elpa'
;; target run to generate .info files and the version.texi that
;; auctex.texi @includes.  Rather than re-run that build locally,
;; redirect :repo to github.com/emacs-straight/<pkg> -- a plain git
;; mirror whose contents are the released ELPA tarball applied as
;; commits.  That ships the prebuilt .info files and any generated
;; .el, so no build dance is needed.  Same trick straight.el uses by
;; default.
;;
;; Menu order: GNU-ELPA first so this hook fires for anything in it;
;; MELPA before NonGNU-ELPA because MELPA carries curated :files
;; directives (e.g. "modes/*/*.el" for evil-collection,
;; "lisp/*.el" + "server/epdfinfo" for pdf-tools) while NonGNU-ELPA
;; uses a flat ("*" ...) that doesn't flatten subdirs.

(setq elpaca-menu-functions
      '( elpaca-menu-lock-file elpaca-menu-extensions elpaca-menu-org
         elpaca-menu-gnu-elpa elpaca-menu-melpa elpaca-menu-nongnu-elpa
         elpaca-menu-declarations))

(defun +elpaca/use-emacs-straight-mirror (recipe)
  "Hook for `elpaca-recipe-functions'."
  (when (equal (plist-get recipe :source) "GNU ELPA")
    (let ((pkg (plist-get recipe :package)))
      (list :repo (cons (format "https://github.com/emacs-straight/%s.git" pkg) pkg)
            :host nil
            :branch nil))))

(add-hook 'elpaca-recipe-functions #'+elpaca/use-emacs-straight-mirror)

;; elpaca-build-link symlinks whole subdirectories into the build dir
;; (e.g. `modes/' from evil-collection, `lisp/' from pdf-tools).
;; elpaca's autoload generator runs in an `emacs -Q' subprocess that
;; uses `elpaca--directory-files-recursively', which refuses to follow
;; symlinks -- so the resulting autoloads file misses everything in
;; those subdirs.  Replace the step with one that injects a
;; symlink-following recursor into the subprocess.
(defun +elpaca/build-autoloads-with-follow (e)
  "Replacement for `elpaca-build-autoloads' that follows symlinks."
  (if-let* ((recipe (elpaca<-recipe e))
            (autoloads (let ((member (plist-member recipe :autoloads)))
                         (if member (cadr member) t)))
            (default-directory (elpaca<-build-dir e))
            (elpaca (expand-file-name "elpaca/" elpaca-sources-directory)))
      (progn
        (elpaca-note e (concat "Generating autoloads: " default-directory))
        (elpaca-with-emacs e
          (:name "autoloads" :args ("-L" elpaca "-l" (expand-file-name "elpaca.el" elpaca)))
          (defun +elpaca/dfr-follow (directory regexp)
            (let ((default-directory (expand-file-name directory)))
              (flatten-tree
               (cl-loop for file in (directory-files ".")
                        unless (string-match-p "\\(?:\\`\\.\\)" file)
                        collect (if (file-directory-p file)
                                    (+elpaca/dfr-follow file regexp)
                                  (when (string-match-p regexp file)
                                    (expand-file-name file)))))))
          (advice-add 'elpaca--directory-files-recursively :override
                      #'+elpaca/dfr-follow)
          ,@(when (stringp autoloads) `((setq generated-autoload-file ,autoloads)))
          (elpaca-generate-autoloads ,(elpaca<-package e) ,default-directory)))
    (elpaca-continue e)))

(with-eval-after-load 'elpaca
  (setq elpaca-default-build-steps
        (mapcar (lambda (step)
                  (if (eq step 'elpaca-build-autoloads)
                      '+elpaca/build-autoloads-with-follow
                    step))
                elpaca-default-build-steps)))

;;;; ============================================================
;;;; 4. Custom build steps
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


(defun +elpaca/run-make (e &rest args)
  "Run \"make ARGS\" in E's repo dir, then `elpaca-continue' on success.
Shared implementation for the named build-step functions below. Replaces
the dropped `:pre-build' recipe keyword."
  (let ((cmd (cons "make" args)))
    (elpaca-note e (format "Running %s" (string-join cmd " ")))
    (let ((default-directory (elpaca<-source-dir e)))
      (elpaca--make-process e
        :name "make"
        :command cmd
        :sentinel
        (lambda (process event)
          (let* ((e (process-get process :elpaca))
                 (ok (equal event "finished\n")))
            (elpaca--propertize-subprocess process)
            (elpaca-note e (if ok "make succeeded"
                             (concat "make failed: " (string-trim event))))
            (unless ok (setf (elpaca<-status e) 'failed))
            (elpaca-continue e)))))))

(defun +elpaca/build-step-make (e)       "Run plain `make'."       (+elpaca/run-make e))
(defun +elpaca/build-step-make-doc (e)   "Run `make doc'."         (+elpaca/run-make e "doc"))

;;;; ============================================================
;;;; 5. Diagnostics
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
