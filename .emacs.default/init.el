;; ;;in init.el, before any `require` calls:
;; Add lisp directory and all its subdirectories to load-path
(let ((default-directory (expand-file-name "lisp" user-emacs-directory)))
  (add-to-list 'load-path default-directory)
  (normal-top-level-add-subdirs-to-load-path))

(require 'hooks)
(require 'packages)
(require 'mappings)
(require 'settings)
(require 'eshell-config)

;;;;(defgroup A-custom-group nil
;;;;  "A custom group for my configuration."
;;;;  :group 'convenience)
;;;;
;;;;(defcustom my-alist-settings-options
;;;;  nil
;;;;  "Feature settings with predefined options."
;;;;  :type '(alist :key-type (symbol :tag "Feature")
;;;;                :value-type (boolean :tag "Enabled"))
;;;;  :options '("foo" "bar")
;;;;  :group 'A-custom-group)
;;;;
;;;;
;;;;
;;;;(defcustom my-choice
;;;;  "blabla"
;;;;  "Feature settings with predefined options."
;;;;  :type '(radio 
;;;;           (integer :tag "Number of spaces")
;;;;        (string :tag "Literal text")
;;;;        )  
;;;;  :group 'A-custom-group)
;;;;(custom-set-variables
;; ;; custom-set-variables was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(custom-enabled-themes '(nord))
;; '(custom-safe-themes
;;   '("4c7228157ba3a48c288ad8ef83c490b94cb29ef01236205e360c2c4db200bb18" default)))
;;(custom-set-faces
;; ;; custom-set-faces was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your inwdit file should contain only one such instance.u;; ;; If there is more than one, they won't work right.
;; )
;;
;;
;;
