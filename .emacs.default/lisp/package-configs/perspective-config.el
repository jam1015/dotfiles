(use-package perspective
  :demand t
  :custom
  (persp-sort 'name)
  (persp-suppress-no-prefix-key-warning t)
  :config
  (persp-mode)
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
                  (let ((persp-bufs (persp-current-buffers)))
                    (consult--buffer-query
                     :sort 'visibility
                     :predicate (lambda (buf) (memq buf persp-bufs))
                     :as #'consult--buffer-pair))))
      "Consult source for current perspective buffers.")
    (add-to-list 'consult-buffer-sources 'consult--source-perspective-buffer)
    (consult-customize consult-source-buffer :hidden t :default nil))

  (with-eval-after-load 'project
    (defun my/persp-switch-for-project (&rest _)
      "Switch to a perspective named after the current project root."
      (when-let* ((proj (project-current nil))
                  (root (project-root proj))
                  (name (file-name-nondirectory
                         (directory-file-name root))))
        (persp-switch name)))
    (advice-add 'project-switch-project :after #'my/persp-switch-for-project)))

(provide 'perspective-config)
;;;end perspective-config.el
