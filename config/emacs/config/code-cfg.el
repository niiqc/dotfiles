(use-package eglot
	:ensure nil
	:bind (("C-." . eglot-code-actions))
	:custom (eglot-autoshutdown t)
	)

(use-package reformatter
	:defer t
	:ensure t
	:hook (python-mode . ruff-format-on-save-mode)
	:hook (python-ts-mode . ruff-format-on-save-mode)
	:hook (tsx-ts-mode . biome-format-on-save-mode)
	:hook (typescript-ts-mode . biome-format-on-save-mode)
	:config
	(reformatter-define biome-format
		:program "biome"
		:args (list "format"
								"--stdin-file-path"
								(or buffer-file-name "-")))
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
		 (dolist (pkg '("rassumfrassum" "zuban" "ruff" "vtsls" "biome" "html-lsp" "css-lsp"))
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
	:defer t
	:custom
	(magit-format-file-function #'magit-format-file-nerd-icons)
	:ensure t)

;; Diff-hl
(use-package diff-hl
	:ensure t
	:defer t
	:config
	(diff-hl-flydiff-mode)
	(add-hook 'diff-hl-mode-hook 'diff-hl-show-hunk-mouse-mode)
	:hook ((magit-pre-refresh		. diff-hl-magit-pre-refresh)
				 (magit-post-refresh	. diff-hl-magit-post-refresh)
				 (vc-checkin					. diff-hl-update)
				 (dired-mode					. diff-hl-dired-mode)
				 (diff-hl-mode-hook		. diff-hl-show-hunk-mouse-mode))
	:init (global-diff-hl-mode))


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
;; Html | css
;; ======================================================================
(use-package edit-indirect
	:defer t
	:vc (:url "https://github.com/Fanael/edit-indirect.git"
						:branch "master"))

(use-package web-mode
	:ensure t
	:hook (web-mode . web-mode-use-tabs)
	:mode ("\\.html\\'"))

(use-package eglot
	:ensure nil
	:config
	(add-to-list
	 'eglot-server-programs
	 '((web-mode :language-id "html")
		 . ("rass"
				"--"
				"biome" "lsp-proxy"
				"--"
				"vscode-html-language-server" "--stdio")))

	(defun my/html-edit-indirect (beg end mode ext)
		(edit-indirect-region beg end t)
		(with-current-buffer (current-buffer)
			(setq buffer-file-name
						(format "%s.-ei-.%s"
										(buffer-file-name (buffer-base-buffer))
										ext))
			(funcall mode)))

	(defun my/html-edit-style ()
		(interactive)
		(save-excursion
			(when (search-backward "<style" nil t)
				(search-forward ">")
				(let ((beg (point)))
					(when (search-forward "</style>" nil t)
						(my/html-edit-indirect
						 beg
						 (match-beginning 0)
						 #'css-ts-mode
						 "css"))))))

	(defun my/html-edit-script ()
		(interactive)
		(save-excursion
			(when (search-backward "<script" nil t)
				(search-forward ">")
				(let ((beg (point)))
					(when (search-forward "</script>" nil t)
						(my/html-edit-indirect
						 beg
						 (match-beginning 0)
						 #'js-ts-mode
						 "js"))))))

	(with-eval-after-load 'web-mode
		(keymap-set web-mode-map "C-c '" #'my/html-edit-script)
		(keymap-set web-mode-map "C-c \\" #'my/html-edit-style))
	:hook (web-mode . eglot-ensure))

(use-package eglot
	:ensure nil
	:config
	(add-to-list
	 'eglot-server-programs
	 '((css-ts-mode :language-id "css")
		 (css-mode :language-id "css")
		 . ("rass"
				"--"
				"biome" "lsp-proxy"
				"--"
				"vscode-css-language-server" "--stdio")))
	:hook ((css-ts-mode css-mode) . eglot-ensure))

(use-package yasnippet
	:defer t
	:ensure t
	:config
	(yas-global-mode 1))

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
;; Fish
;; ======================================================================

(use-package fish-mode
	:defer t
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
	:defer t
	:ensure t)

;; ======================================================================
;; Mermaid
;; ======================================================================
(use-package mermaid-mode
	:ensure t
	:defer t
	:mode ("\\.mmd\\'"))

(provide 'code-cfg)
