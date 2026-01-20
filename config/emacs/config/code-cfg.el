(use-package eglot
	:ensure nil
	:bind (("C-." . eglot-code-actions))
	:custom (eglot-autoshutdown t)
	)

(use-package reformatter
  :ensure t
  :config
	(add-hook 'python-mode-hook 'ruff-format-on-save-mode)
	(add-hook 'python-ts-mode-hook 'ruff-format-on-save-mode)
  (reformatter-define ruff-format
		:program "ruff"
		:args (list "format"
								"--stdin-filename"
								(or buffer-file-name "")
								"-")))

(use-package mason
	:config
	(mason-ensure
	 (lambda ()
		 (dolist (pkg '("rassumfrassum" "zuban" "ruff"))
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

(use-package flymake
	:custom (flymake-fringe-indicator-position nil)
	:ensure nil)

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
	(add-hook 'writeroom-mode-hook
						(lambda ()
							(if writeroom-mode
									(diff-hl-margin-local-mode-off)
								(diff-hl-margin-local-mode))
							(diff-hl-update)))
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
											 '(python-base-mode . ("rass" "--" "zuban" "server" "--" "ruff" "server")))
	:hook (python-base-mode . eglot-ensure))

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
