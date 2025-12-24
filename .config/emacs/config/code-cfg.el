
;; LSP configuration
(use-package lsp-mode
	:commands (lsp lsp-deferred)
	:hook (lsp-mode . lsp-enable-which-key-integration)
	:custom
	(lsp-auto-configure t)
	(lsp-completion-provider :none) ;; We use corfu instead
	(lsp-log-io nil)
	:ensure t)

(use-package lsp-diagnostics
	:after flycheck
	:config (lsp-diagnostics-flycheck-enable))

(use-package lsp-ui
	:commands lsp-ui-mode
	:custom
	(lsp-ui-sideline-show-diagnostics t)
	(lsp-ui-sideline-show-code-actions t)
	(lsp-ui-doc-position 'at-point)
	(lsp-ui-doc-show-with-mouse t)
	(lsp-ui-doc-show-with-cursor nil)
	(lsp-ui-doc-enable t)
	(lsp-headerline-breadcrumb-enable nil)
	(lsp-ui-doc-delay 0)
	:ensure t)

;; TODO: Think about lsp-treemacs
;; (use-package lsp-treemacs
;;		:commands lsp-treemacs-errors-list
;;		:after treemacs lsp-mode
;;	 ;; :custom
;;	 ;; (lsp-treemacs-theme "nerd-icons-ext")
;;		:config
;;		(lsp-treemacs-sync-mode 1)
;;		:ensure t)

;; Dap debugger
(use-package dap-mode
	:custom
	(dap-auto-configure-features '(sessions locals tooltip))
	:config
	(setq lsp-enable-dap-auto-configure nil)
	(with-eval-after-load 'dap-ui
		(unless (display-graphic-p)
			(set-face-background 'dap-ui-marker-face "color-166")
			(set-face-attribute 'dap-ui-marker-face nil :inherit nil)
			(set-face-background 'dap-ui-pending-breakpoint-face "blue")
			(set-face-attribute 'dap-ui-verified-breakpoint-face nil
													:inherit 'dap-ui-pending-breakpoint-face)))
	:ensure t)

;; Fly check
(use-package flycheck
	:ensure t
	:init (global-flycheck-mode))

;; Projectile
(use-package projectile
	:ensure t
	:config
	(projectile-mode t)
	:custom
	(projectile-project-search-path '("/home/nick/.config/emacs" "/home/nick/Documents/Notes"))
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


;; Python configuration
(use-package lsp-mode
	:custom
	(lsp-ruff-server-command "")
	;; (lsp-pylsp-server-command '("/home/nick/.config/emacs/com-pkgs/python/bin/pylsp"))
	(lsp-pylsp-plugins-ruff-enabled t)
	(lsp-pylsp-plugins-mypy-enabled t)
	(lsp-pylsp-plugins-mypy-report-progress t)
	(lsp-pylsp-plugins-flake8-enabled nil)
	(lsp-pylsp-plugins-pydocstyle-enabled nil)
	:hook ((python-mode python-ts-mode) . lsp-deferred))

(use-package dap-python
	:config (dap-auto-configure-mode t)
	:custom (dap-python-debugger 'debugpy)
	:config
	(dap-node-setup)
	:hook (((python-mode python-ts-mode) . dap-ui-mode)
				 ((python-mode python-ts-mode) . dap-mode)))

(defun my/python-tab-setup ()
	"Ensure Python uses literal tabs and proper visual width."
	(dtrt-indent-mode t)
	(setq-local tab-width 2)

	(when indent-tabs-mode
		(setq-local indent-line-function #'tab-to-tab-stop)
		)

	(unless indent-tabs-mode
		(setq-local python-indent-offset standard-indent)
		)
	)

(add-hook 'python-ts-mode-hook #'my/python-tab-setup)

;; Fish mode
(use-package fish-mode
	:ensure t)

(add-hook 'fish-mode-hook (lambda () (add-hook 'before-save-hook 'fish_indent-before-save)))

(provide 'code-cfg)
