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
;;;; 3. Recipe fixes (info pages, source layout)
;;;; ============================================================
;; One hook that resolves every problem we've hit:
;;
;; GNU-ELPA packages (auctex, ess, ...) -- redirect :repo to the
;; matching github.com/emacs-straight/<pkg> mirror.  Those mirrors
;; are the released ELPA tarball applied as git commits, so they
;; ship with .info files already built, generated .el already
;; produced, and a flat top-level layout.  Everything "just works"
;; downstream: no makeinfo, no @include-fragment confusion, no
;; symlinked subdirs tripping autoload generation.
;;
;; NonGNU-ELPA packages (eat, pdf-tools, ...) -- NonGNU-ELPA's
;; default :files directive is ("*" (:exclude ...)), which tells
;; elpaca "link every top-level entry."  For packages whose elisp
;; lives under `lisp/', this symlinks the whole subdir and breaks
;; autoload generation; it also drags along license .texi fragments
;; (fdl.texi, gpl.texi) that aren't standalone manuals but still get
;; fed to makeinfo, triggering elpaca #241 (the -o batching bug).
;; Rewriting :files to a MELPA-style flat directive fixes both: elisp
;; from lisp/ gets flattened to the build dir top level, and the
;; license fragments are excluded.

(setq elpaca-menu-functions
      '( elpaca-menu-lock-file elpaca-menu-extensions elpaca-menu-org
         elpaca-menu-gnu-elpa elpaca-menu-nongnu-elpa elpaca-menu-melpa
         elpaca-menu-declarations))

(defun +elpaca/fix-recipe (recipe)
  "Hook for `elpaca-recipe-functions'.  See section 3 commentary."
  (pcase (plist-get recipe :source)
    ("GNU ELPA"
     (let ((pkg (plist-get recipe :package)))
       (list :repo (cons (format "https://github.com/emacs-straight/%s.git" pkg) pkg)
             :host nil
             :branch nil)))
    ("NonGNU ELPA"
     (let ((f (plist-get recipe :files)))
       (when (and (consp f) (equal (car f) "*"))
         (list :files
               '("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                 "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                 "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el"
                           "*-test.el" "*-tests.el" "LICENSE"
                           "README*" "*-pkg.el"
                           ;; @include-only license fragments that
                           ;; break makeinfo -o batching (elpaca #241)
                           "fdl.texi" "gpl.texi" "license.texi"
                           "doc/fdl.texi" "doc/gpl.texi"
                           "doc/license.texi"))))))))

(add-hook 'elpaca-recipe-functions #'+elpaca/fix-recipe)

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
