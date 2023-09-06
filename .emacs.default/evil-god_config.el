
;; Define a function to toggle evil/emacs state and god-mode
(defun my-toggle-evil-emacs-and-god-mode ()
  "Toggle between evil and emacs state, then toggle god-mode."
  (interactive)
  (cond
   
   ( (eq evil-state 'insert) 
     (god-mode-all))
   ;; (insert, on) -> (emacs, off)
   ;;((and (eq evil-state 'insert) (bound-and-true-p god-local-mode))
    ;;(evil-insert-state)
    ;;(god-mode-all)
    ;;)
   ;;;; (insert, off) -> (emacs, off)
   ;;((and (eq evil-state 'insert) (not (bound-and-true-p god-local-mode)))
    ;;(evil-insert-state)
    ;;)
   ;; (normal+ , on) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs))) (bound-and-true-p god-local-mode))
    (evil-insert-state)
    )
   ;; (normal+ , off) -> (emacs, on)
   ((and (not (or (eq evil-state 'insert) (eq evil-state 'emacs))) (not (bound-and-true-p god-local-mode)))
    (evil-insert-state)
    (god-mode-all))
   (t (god-mode-all))

   )
  )

;; Configure keybindings

;;(define-key global-map (kbd "C-,") 'my-toggle-evil-emacs-and-god-mode)

(define-key god-local-mode-map (kbd ".") #'repeat)

(defun disable-god-mode-in-evil-normal-state ()
  "Disable `god-mode' when entering `evil-normal-state'."
  (when (and (bound-and-true-p god-global-mode)
	     (eq evil-state 'normal))
    (god-mode-all)))

(add-hook 'evil-normal-state-entry-hook 'disable-god-mode-in-evil-normal-state)



(evil-set-initial-state 'Info-mode 'insert)


(defun my-info-mode-settings ()
  (god-local-mode 1))

(add-hook 'Info-mode-hook 'my-info-mode-settings)



(require 'evil)


(defun update-cursor-according-to-mode ()
  (cond
   ((and (eq evil-state 'insert) god-local-mode)
    (setq cursor-type 'box)
    (set-cursor-color "red"))
   ((or (eq evil-state 'insert) god-local-mode)
    (setq cursor-type 'bar)
    (set-cursor-color "red"))
   (t
    (setq cursor-type 'box)
    (set-cursor-color "black"))))

(add-hook 'post-command-hook 'update-cursor-according-to-mode)
(add-hook 'buffer-list-update-hook 'update-cursor-according-to-mode)

(custom-set-faces
 '(god-mode-lighter ((t (:inherit error)))))
