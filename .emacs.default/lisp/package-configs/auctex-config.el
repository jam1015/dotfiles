;; -*- lexical-binding: t; -*-
(use-package auctex
  :ensure (auctex :pre-build (("make"))
                  :files (:defaults "doc/*.info" "doc/dir"
                                    "etc" "images" "latex" "style"))
  :defer t
  :mode ("\\.tex\\'" . LaTeX-mode)
  :init
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil
        TeX-source-correlate-method 'synctex
        TeX-source-correlate-start-server nil
        LaTeX-biblatex-use-Biber t
        TeX-output-dir "out")
  (setq-default TeX-master nil)
  :config
  ;; latexmk engine flag mirrors AUCTeX's TeX-engine (set by `%! TeX program').
  (defun my/latexmk-engine-flag ()
    (pcase TeX-engine
      ('xetex  "-pdfxe")
      ('luatex "-pdflua")
      (_       "-pdf")))
  (add-to-list 'TeX-expand-list
               '("%(latexmk-engine)" (lambda () (my/latexmk-engine-flag))))
  ;; vimtex's build_dir has no latexmk CLI equivalent; only aux/out are mapped.
  (add-to-list 'TeX-command-list
               '("LatexMk"
                 "latexmk %(latexmk-engine) -auxdir=aux -outdir=out -synctex=1 -interaction=nonstopmode -view=none %t"
                 TeX-run-TeX t (latex-mode LaTeX-mode)
                 :help "Run latexmk once"))
  (setq TeX-command-default "LatexMk")
  (add-hook 'LaTeX-mode-hook
            (lambda () (setq-local TeX-command-default "LatexMk")))

  (defun my/latex-latexmk ()
    "Run the LatexMk TeX-command on the master file, no prompt."
    (interactive)
    (TeX-save-document (TeX-master-file))
    (TeX-command "LatexMk" #'TeX-master-file -1))

(require 'pdf-sync)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (add-to-list 'TeX-view-program-list
               '("PDF Tools" TeX-pdf-tools-sync-view))
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)

  (TeX-source-correlate-mode 1)

  (defun my/latex-rebuild-on-save ()
    (when (and (derived-mode-p 'LaTeX-mode 'latex-mode)
               (not (TeX-process (TeX-master-file))))
      (my/latex-latexmk)))
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (add-hook 'after-save-hook #'my/latex-rebuild-on-save nil t)))

  (my/mappings-auctex))

(provide 'auctex-config)
;;;end auctex-config.el
