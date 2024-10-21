(defun load-relative (file)
  "Load FILE relative to the current source file."
  (load-file (expand-file-name file (file-name-directory (or load-file-name buffer-file-name)))))

(load-relative "hooks.el")
(load-relative "packages.el")
(load-relative "mappings.el")
(load-relative "settings.el")

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
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; )
;;
;;
;;
;;;;(load-theme 'nord t)

