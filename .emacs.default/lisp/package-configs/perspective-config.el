;; persp-mode.el (Bad-ptr / Kulikov), NOT perspective.el (Nex3).
;; Perspectives are global; each frame holds a pointer to one via a
;; frame parameter, so multiple frames can share a perspective (and thus
;; a buffer list) or each frame can sit on its own perspective.

(use-package persp-mode
  :ensure t
  :demand t
  :custom
  (persp-nil-name "none")                  ; the catch-all perspective (sees every buffer)
  (persp-auto-resume-time -1)              ; don't autoload perspectives at startup
  (persp-auto-save-opt 0)                  ; don't autosave on exit
  (persp-set-last-persp-for-new-frame nil) ; new frames start in `persp-nil-name', not the last-used persp
  (persp-add-buffer-on-after-change-major-mode t)
  (persp-suppress-no-prefix-key-warning t)
  :config
  (persp-mode 1)
  (my/mappings-perspective)

  (with-eval-after-load 'consult
    (defvar consult--source-perspective-buffer
      `(:name "Perspective Buffers"
        :narrow ?p
        :category buffer
        :face consult-buffer
        :history buffer-name-history
        :state ,#'consult--buffer-state
        :default t
        :items ,(lambda ()
                  (let ((persp-bufs (persp-buffer-list-restricted)))
                    (consult--buffer-query
                     :sort 'visibility
                     :predicate (lambda (buf) (memq buf persp-bufs))
                     :as #'consult--buffer-pair))))
      "Consult source for the current frame's perspective buffers.")
    (add-to-list 'consult-buffer-sources 'consult--source-perspective-buffer)
    (consult-customize consult-source-buffer :hidden t :default nil)))

(provide 'perspective-config)
;;;end perspective-config.el
