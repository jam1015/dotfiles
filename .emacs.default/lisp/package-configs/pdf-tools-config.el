;;; -*- lexical-binding: t; -*-
(use-package pdf-tools
  :defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :preface
  (defun my/pdf-view-buffer-p (buf _action)
    "Non-nil when BUF is a pdf-view buffer."
    (with-current-buffer buf
      (derived-mode-p 'pdf-view-mode)))
  (defun my/pdf-view-disable-line-numbers ()
    "pdf-view-mode is incompatible with display-line-numbers-mode."
    (display-line-numbers-mode -1))
  :hook ((pdf-view-mode . my/pdf-view-disable-line-numbers)
         (pdf-view-mode . pdf-tools-enable-minor-modes)
         (pdf-view-mode . pdf-sync-minor-mode))
  :custom
  (pdf-view-display-size 'fit-page)
  (pdf-sync-backward-display-action
   '((display-buffer-reuse-window)
     (reusable-frames . visible)
     (inhibit-same-window . t)))
  (pdf-sync-forward-display-action
   '((display-buffer-reuse-window)
     (reusable-frames . visible)
     (inhibit-same-window . t)))
  :config
  (unless (and pdf-info-epdfinfo-program
               (file-executable-p pdf-info-epdfinfo-program))
    (pdf-tools-install :no-query))
  (add-to-list 'display-buffer-alist
               `(my/pdf-view-buffer-p
                 (display-buffer-reuse-window display-buffer-pop-up-frame)
                 (reusable-frames . visible)
                 (pop-up-frame-parameters . ((width . 100) (height . 50))))))

(provide 'pdf-tools-config)
;;;end pdf-tools-config.el
