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
   '((display-buffer-reuse-window display-buffer-pop-up-frame)
     (reusable-frames . visible)
     (inhibit-same-window . t)
     (pop-up-frame-parameters . ((width . 100) (height . 50)
                                 (unsplittable . t)
                                 (no-other-window . t)))))
  (pdf-sync-forward-display-action
   '((display-buffer-reuse-window display-buffer-pop-up-frame)
     (reusable-frames . visible)
     (inhibit-same-window . t)
     (pop-up-frame-parameters . ((width . 100) (height . 50)
                                 (unsplittable . t)
                                 (no-other-window . t)))))
  :config
  (unless (and pdf-info-epdfinfo-program
               (file-executable-p pdf-info-epdfinfo-program))
    (pdf-tools-install :no-query))
  (add-to-list 'display-buffer-alist
               `(my/pdf-view-buffer-p
                 (display-buffer-reuse-window display-buffer-pop-up-frame)
                 (reusable-frames . visible)
                 (pop-up-frame-parameters . ((width . 100) (height . 50)
                                             (unsplittable . t)
                                             (no-other-window . t))))))

;; Make evil-collection's pdf `y' behave like `evil-yank-characters':
;; always `kill-new' (=> clipboard via xclip-mode) unless the register is
;; `_', also fill a named register when given one, and update "0 when
;; yanked without a register.  Upstream only sets the register, so "ay
;; never reached the kill ring/clipboard and "0 was never updated.
(defun my/evil-collection-pdf-yank ()
  "Yank the active pdf-view region the same way `evil-yank' would."
  (interactive)
  (pdf-view-assert-active-region)
  (let ((text (mapconcat #'identity (pdf-view-active-region-text) nil))
        (register evil-this-register))
    (pdf-view-deactivate-region)
    (when register
      (evil-set-register register text))
    (unless register
      (evil-set-register ?0 text))
    (unless (eq register ?_)
      (kill-new text))))

(with-eval-after-load 'evil-collection-pdf
  (advice-add 'evil-collection-pdf-yank :override #'my/evil-collection-pdf-yank))

(provide 'pdf-tools-config)
;;;end pdf-tools-config.el
