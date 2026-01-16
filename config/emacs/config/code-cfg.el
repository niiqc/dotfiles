(use-package eglot
	:ensure nil
	:bind (("C-." . eglot-code-actions))
	:custom (eglot-autoshutdown t)
	)

(use-package mason
	:config
	(mason-ensure
	 (lambda ()
		 (dolist (pkg '("zuban" "ruff"))
			 (unless (mason-installed-p pkg)
				 (ignore-errors (mason-install pkg))))))
	:ensure t
	)

(use-package dape
	:custom
	(dape-buffer-window-arrangement 'right)
	(dape-request-timeout 60)
	:ensure t
	)

(use-package flymake-ruff
	:ensure t
	:custom (python-flymake-command nil)
	:hook (eglot-managed-mode . flymake-ruff-load)
	)

(use-package treesit-auto
	:config
	(global-treesit-auto-mode)
	;; Define itens to install
	(dolist (lang '(bash c cpp css dockerfile html json lua python rust yaml))
		(unless (treesit-language-available-p lang)
			(treesit-install-language-grammar lang)))
	:custom
	(treesit-auto-install t)
	(treesit-font-lock-level 4)
	:init
	(setq treesit-language-source-alist
				'((bash				. ("https://github.com/tree-sitter/tree-sitter-bash.git" "v0.23.3"))
					(c					. ("https://github.com/tree-sitter/tree-sitter-c.git" "v0.23.6"))
					(cpp				. ("https://github.com/tree-sitter/tree-sitter-cpp.git" "v0.23.4"))
					(css				. ("https://github.com/tree-sitter/tree-sitter-css.git" "v0.23.2"))
					(dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile" "v0.2.0"))
					(elixir			. ("https://github.com/elixir-lang/tree-sitter-elixir" "v0.3.4"))
					(html				. ("https://github.com/tree-sitter/tree-sitter-html.git" "v0.23.2"))
					(json				. ("https://github.com/tree-sitter/tree-sitter-json.git" "v0.24.8"))
					(lua				. ("https://github.com/tree-sitter-grammars/tree-sitter-lua" "v0.3.0"))
					(python			. ("https://github.com/tree-sitter/tree-sitter-python.git" "v0.23.6"))
					(rust				. ("https://github.com/tree-sitter/tree-sitter-rust.git" "v0.23.3"))
					(yaml				. ("https://github.com/tree-sitter-grammars/tree-sitter-yaml.git" "v0.7.2"))
					))
	:ensure t
	)

(use-package magit
	:custom
	(magit-format-file-function #'magit-format-file-nerd-icons)
	:ensure t)

(use-package magit-todos
	:ensure t
	:after magit
	:config
	(magit-todos-mode)
	(global-hl-todo-mode)
	(with-eval-after-load 'hl-todo
		(setq hl-todo-keyword-faces
					`(("TODO" warning bold)
						("FIXME" error bold)
						("HACK" font-lock-constant-face bold)
						("REVIEW" font-lock-keyword-face bold)
						("NOTE" success bold)
						("DEPRECATED" font-lock-doc-face bold)))))

;; Diff-hl
(use-package diff-hl
	:after magit
	:ensure t
	:config
	(diff-hl-flydiff-mode)
	(diff-hl-margin-mode)
	(add-hook 'diff-hl-mode-hook 'diff-hl-show-hunk-mouse-mode)
	:hook ((magit-pre-refresh	 . diff-hl-magit-pre-refresh)
				 (magit-post-refresh . diff-hl-magit-post-refresh)
				 (vc-checkin				 . diff-hl-update)
				 (diff-hl-mode-hook	 . diff-hl-show-hunk-mouse-mode))
	:init (global-diff-hl-mode))


;; ======================================================================
;; Python
;; ======================================================================

(use-package eglot
	:ensure nil
	:config (add-to-list 'eglot-server-programs
											 '(python-base-mode . ("zuban" "server")))
	:hook (python-base-mode . (lambda () (eglot-ensure))))

(use-package python
	:ensure nil
	:hook
	(python-ts-mode . (lambda ()
											(setq-local indent-tabs-mode t)
											(setq-local tab-width 2)
											(setq-local python-indent-offset 2)
											(python-indent-guess-indent-offset)
											(setq-local tab-width python-indent-offset)
											(dtrt-indent-mode 0)
											(dtrt-indent-mode t)
											))
	)

;; ======================================================================
;; Fish
;; ======================================================================

(use-package fish-mode
	:hook (fish-mode-hook . (lambda () (add-hook 'before-save-hook 'finish_indent-before-save)))
	:ensure t)

;; ======================================================================
;; Json
;; ======================================================================

(use-package json
  :config
  (eval-after-load 'json-ts-mode
    '(progn
       (define-key json-ts-mode-map (kbd "M-F") #'json-pretty-print-buffer)))
  :ensure nil
  :hook (json-ts-mode . (lambda () (add-hook 'before-save-hook #'json-pretty-print-buffer)))
  )

;; ======================================================================
;; Guile
;; ======================================================================

(use-package geiser-guile
	:ensure t
	)

(provide 'code-cfg)
