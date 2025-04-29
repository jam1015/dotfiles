;; Set up package.el to work with MELPA
(blink-cursor-mode 0)
(require 'package)
(add-to-list 'package-archives
'("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(package-refresh-contents)


;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))
(unless (package-installed-p 'god-mode)
  (package-install 'god-mode))
;
(unless (package-installed-p 'evil-god-state)
  (package-install 'evil-god-state))


;; Enable Evil
(require 'evil)
(evil-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-set-key (kbd "C-,") 'evil-execute-in-god-state)
