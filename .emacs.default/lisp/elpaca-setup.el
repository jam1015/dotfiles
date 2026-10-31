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
;;;; 3. Info-pages fix
;;;; ============================================================
;; Make info pages work out of the box the way straight.el does.
;;
;; (1) Resolve recipes via GNU/NonGNU ELPA before MELPA.  For packages
;;     available from both, this picks up the ELPA metadata (:tar <ver>,
;;     :source "GNU ELPA").
;;
;; (2) For GNU-ELPA recipes, redirect :repo to the matching
;;     github.com/emacs-straight/<pkg> mirror -- a plain git repo whose
;;     contents are the released ELPA tarball applied as commits.  Those
;;     tarballs ship built .info files and the generated .el that only
;;     the package's Makefile would otherwise produce (notably auctex).
;;     Still :type git, no tarballs.
;;
;; (3) `+elpaca/build-info-robust' replaces elpaca's own info build
;;     step for anything that reaches it with raw .texi.  Fixes:
;;      - the makeinfo -o batching behavior (elpaca #241),
;;      - .texi only present under doc/,
;;      - @include-fragment .texi being fed as standalone manuals.
;;     This handles MELPA packages, NonGNU-ELPA packages, and any
;;     straggler not covered by (2).
;;
;; (4) `elpaca--directory-files-recursively' is overridden to follow
;;     symlinks, so autoload generation can see into subdirectories
;;     (e.g. `lisp/') that build-link symlinked as a whole.  Without
;;     this, packages with a NonGNU-ELPA-style :files ("*" ...)
;;     recipe fail autoload generation with "No elisp files".

(setq elpaca-menu-functions
      '( elpaca-menu-lock-file elpaca-menu-extensions elpaca-menu-org
         elpaca-menu-gnu-elpa elpaca-menu-nongnu-elpa elpaca-menu-melpa
         elpaca-menu-declarations))

(defun +elpaca/use-emacs-straight-mirror (recipe)
  "Hook for `elpaca-recipe-functions'.
If RECIPE came from GNU ELPA, rewrite :repo to the matching
`github.com/emacs-straight/<package>' git mirror, which carries
built .info and generated .el.  Returns a plist merged over RECIPE."
  (when (equal (plist-get recipe :source) "GNU ELPA")
    (let ((pkg (plist-get recipe :package)))
      (list :repo (cons (format "https://github.com/emacs-straight/%s.git" pkg) pkg)
            :host nil
            :branch nil))))

(add-hook 'elpaca-recipe-functions #'+elpaca/use-emacs-straight-mirror)

(defun +elpaca/build-info-robust (e)
  "Replacement for `elpaca-build-docs'.
Scans the source repo for standalone .texi/.texinfo files (those
with @setfilename), runs makeinfo once per file from each file's
own directory so @include resolves, writes .info into the build
dir.  Pushes `elpaca--install-info' onto E's remaining build steps
when any .info was produced so a dir entry gets generated."
  (let* ((repo  (elpaca<-source-dir e))
         (build (elpaca<-build-dir  e))
         (built nil))
    (when (and repo build (file-directory-p repo) (file-directory-p build))
      (dolist (texi (directory-files-recursively repo "\\.texi\\(nfo\\)?\\'"))
        (when-let* ((setname (with-temp-buffer
                               (insert-file-contents texi nil 0 4096)
                               (when (re-search-forward
                                      "^@setfilename[ \t]+\\(\\S-+\\)" nil t)
                                 (match-string 1))))
                    (out (expand-file-name
                          (file-name-nondirectory setname) build))
                    ((not (file-exists-p out))))
          (let ((default-directory (file-name-directory texi)))
            (when (eq 0 (call-process "makeinfo" nil nil nil
                                      "--no-split"
                                      (file-name-nondirectory texi)
                                      "-o" out))
              (setq built t))))))
    (when built
      (cl-pushnew 'elpaca--install-info (elpaca<-build-steps e))))
  (elpaca-continue e))

(with-eval-after-load 'elpaca
  (setq elpaca-default-build-steps
        (mapcar (lambda (step)
                  (if (eq step 'elpaca-build-docs)
                      '+elpaca/build-info-robust
                    step))
                elpaca-default-build-steps)))

;; (4) elpaca's `elpaca--directory-files-recursively' refuses to
;;     follow symlinks.  elpaca-build-link links whole subdirectories
;;     (e.g. `lisp/') as single symlinks when a recipe uses :files
;;     ("*" ...) -- the NonGNU-ELPA default for most packages.  The
;;     autoload step then can't see inside, failing with "No elisp
;;     files in <build-dir>".  Override to recurse through symlinks.
;;     Safe because the function filters `.'-prefixed entries (so
;;     .git is skipped) and build-dir symlinks are one-way into
;;     sources/, so no cycle is possible.
(defun +elpaca/directory-files-recursively-follow (directory regexp)
  "Like `elpaca--directory-files-recursively', but follow symlinks."
  (let ((default-directory (expand-file-name directory)))
    (flatten-tree
     (cl-loop for file in (directory-files ".")
              unless (string-match-p "\\(?:\\`\\.\\)" file)
              collect (if (file-directory-p file)
                          (+elpaca/directory-files-recursively-follow file regexp)
                        (when (string-match-p regexp file)
                          (expand-file-name file)))))))

(with-eval-after-load 'elpaca
  (advice-add 'elpaca--directory-files-recursively :override
              #'+elpaca/directory-files-recursively-follow))

;;;; ============================================================
;;;; 4. Custom build steps
;;;; ============================================================
;; Reusable build-step functions that packages can opt into via
;; `:ensure (:build (... +elpaca/build-step-make ...))'.

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

(defun +elpaca/audit-missing-info ()
  "List elpaca packages that ship .texi sources but have no built .info files.
Flags packages whose manuals are missing from Info because `:pre-build' did
not run or produced no output. Returns the list of package names and
displays it in a buffer."
  (interactive)
  (let (missing)
    (pcase-dolist (`(,id . ,e) (elpaca--queued))
      (let ((repo  (ignore-errors (elpaca<-source-dir e)))
            (build (ignore-errors (elpaca<-build-dir e))))
        (when (and repo (file-directory-p repo))
          (let ((has-texi (directory-files-recursively repo "\\.texi\\'" nil nil t))
                (has-info (and build (file-directory-p build)
                               (directory-files-recursively build "\\.info\\'" nil nil t))))
            (when (and has-texi (not has-info))
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
