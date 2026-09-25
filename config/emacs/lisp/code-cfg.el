;; -*- lexical-binding: t; -*-

(use-package eglot
	:ensure nil
	:bind (("C-." . eglot-code-actions)
				 (:map eglot-mode-map ("C-c e f" . eglot-format-buffer)))
	:custom
	(eglot-ignored-server-capabilities '(:inlayHintProvider))
	(eglot-autoshutdown t)
	(eglot-code-action-indications nil)
	(eldoc-echo-area-use-multiline-p nil)
	(eglot-documentation-renderer 'markdown-ts-view-mode)
	(eldoc-display-functions '(eldoc-display-in-buffer)))

(unless (with-temp-buffer ; Do not install mason when using Guix.
					(when (file-exists-p "/etc/os-release")
						(insert-file-contents "/etc/os-release")
						(re-search-forward "^ID=guix$" nil t)))
	(use-package mason
		:config
		(mason-setup)
		(defun my/mason-install-all ()
			"Intall all LSPs/linters based on a list preset"
			(interactive)
			(dolist (pkg '("rassumfrassum" "zuban" "ruff" "vtsls" "biome"
										 "typos-lsp" "rust-analyzer clangd"))
				(unless (mason-installed-p pkg)
					(ignore-errors (mason-install pkg)))))
		:ensure t))

(use-package dape
	:defer t
	:commands (dape dape-breakpoint-toggle)
	:custom
	(dape-buffer-window-arrangement 'right)
	(dape-request-timeout 60)
	:ensure t)

(use-package flymake
	:ensure nil)

(use-package magit
	:defer t
	:custom
	(magit-format-file-function #'magit-format-file-nerd-icons)
	:ensure t)

;; ======================================================================
;; Javascript
;; ======================================================================
(use-package eglot
	:ensure nil
	:config
	(add-to-list
	 'eglot-server-programs
	 '(((typescript-ts-mode :language-id "typescript")
			(js-ts-mode :language-id "javascript")
			(tsx-ts-mode :language-id "typescriptreact"))
		 . ("rass"
				"--"
				"vtsls" "--stdio"
				"--"
				"biome" "lsp-proxy"
				"--"
				"tailwindcss-language-server" "--stdio")))
	:hook ((tsx-ts-mode js-ts-mode typescript-ts-mode) . eglot-ensure))

(use-package tsx-ts-mode
	:mode ("\\.tsx\\'"))

(use-package js-ts-mode
	:mode ("\\.js\\'"))

(use-package typescript-ts-mode
	:mode ("\\.ts\\'"))

;; ======================================================================
;; Python
;; ======================================================================

(use-package eglot
	:ensure nil
	:config (add-to-list 'eglot-server-programs
											 '(python-base-mode . ("rass" "--" "zuban" "server" "--" "ruff" "server")))
	:hook (python-base-mode . eglot-ensure))

(add-hook 'python-ts-mode-hook
					#'(lambda ()
							(setq-local indent-tabs-mode t
													tab-width 2
													python-indent-offset 2)
							(python-indent-guess-indent-offset)
							(setq-local tab-width python-indent-offset)
							(dtrt-indent-mode 0)
							(dtrt-indent-mode t)))

;; ======================================================================
;; Rust
;; ======================================================================
(use-package eglot
	:config (add-to-list 'eglot-server-programs
											 '(rust-ts-mode . ("rass" "--" "rust-analyzer" "--" "typos-lsp")))
	:ensure nil
	:hook (rust-ts-mode . eglot-ensure))

(add-hook 'rust-ts-mode-hook #'(lambda ()
																 (setq-local indent-tabs-mode t
																						 rust-ts-mode-indent-offset 2)
																 (dtrt-indent-mode 0)
																 (dtrt-indent-mode t)))

;; ======================================================================
;; Fish
;; ======================================================================
(use-package fish-mode
	:defer t
	:hook (fish-mode-hook . (lambda () (add-hook 'before-save-hook 'finish_indent-before-save)))
	:ensure t)

;; ======================================================================
;; Json
;; ======================================================================
(use-package json-ts-mode
	:bind (:map json-ts-mode-map ("C-c e f" . json-pretty-print-buffer))
	:ensure nil)

;; ======================================================================
;; Guile
;; emacs-arei: guix shell emacs emacs-arei -- emacs
;; repl: guix shell guile-ares-rs -- ares-nrepl 
;; ======================================================================
(use-package geiser-guile
	:when (not (locate-library "arei.el"))
	:custom (geiser-mode-start-repl-p t)
	:defer t
	:ensure t)

(use-package geiser
  :when (locate-library "arei.el")
  :custom (geiser-mode-auto-p nil))

(use-package arei
  :when (locate-library "arei.el")
  :init (global-arei-mode))

;; ======================================================================
;; Elisp
;; ======================================================================
(use-package elisp-mode
	:ensure nil
	:bind (:map emacs-lisp-mode-map
							("C-c e f" . (lambda ()
														 (interactive)
														 (indent-region (point-min) (point-max))))))

;; ======================================================================
;; Mermaid
;; ======================================================================
(use-package mermaid-mode
	:ensure t
	:defer t
	:mode ("\\.mmd\\'"))

;; ======================================================================
;; Toml
;; ======================================================================
(use-package toml-ts
	:ensure nil
	:mode (("uv\\.lock" . toml-ts-mode)
				 ("Cargo\\.lock" . toml-ts-mode)))


;; ======================================================================
;; Yaml
;; ======================================================================
(use-package yaml-mode
	:defer t
	:ensure t
	:hook (yaml-ts-mode . (lambda ()
													(setq-local indent-tabs-mode nil)
													(setq-local yaml-indent-offset 2))))

;; ======================================================================
;; Docker
;; ======================================================================
(use-package dockerfile-mode
	:defer t
	:ensure t)

;; ======================================================================
;; C-lang
;; ======================================================================
(use-package eglot
 	:ensure nil
	:config (add-to-list 'eglot-server-programs
											 '(c-ts-mode . ("clangd"
																			"--background-index"
																			"--clang-tidy"
																			"--header-insertion=iwyu"
																			"--completion-style=detailed"
																			"--function-arg-placeholders"
																			"--fallback-style=llvm")))
	:hook (c-ts-mode . eglot-ensure))

(provide 'code-cfg)
