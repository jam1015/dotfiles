(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("evil" . "https://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(evil-mode 1)
(blink-cursor-mode 0)
