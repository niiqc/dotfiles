;; -*- lexical-binding: t; -*-

(use-package catppuccin-theme
	:config
	(load-theme 'catppuccin t)
	:ensure t
	:if (display-graphic-p))

(use-package nerd-icons
	:ensure t
	:custom
	(nerd-icons-font-family "JetBrainsMono Nerd Font Mono"))

(use-package solaire-mode
	:defer t
	:config (solaire-global-mode)
	:hook (dashboard-mode . turn-off-solaire-mode)
	:ensure t	)

;; Dashboard configuration
(use-package dashboard
	:ensure t
	:after general
	:custom
	(dashboard-banner-logo-title "Welcome back.")
	(dashboard-image-banner-max-height 500)
	(dashboard-startup-banner
	 (if (display-graphic-p)(locate-user-emacs-file "main.png") 2))
	(dashboard-page-separator "\n")
	(dashboard-icon-type 'nerd-icons)
	(dashboard-navigation-cycle t)
	(dashboard-set-heading-icons t)
	(dashboard-set-file-icons t)
	(dashboard-vertically-center-content t)
	(dashboard-center-content t)
	(dashboard-items '((recents   . 7)
										 (projects  . 5)))
	:init
	(dashboard-setup-startup-hook))

(use-package doom-modeline
	:defer t
	:custom
	(doom-modeline-indent-info t)
	(doom-modeline-height 25)
	(auto-revert-check-vc-info t)
	(doom-modeline-bar-width 4)
	:ensure t
	:hook (after-init . doom-modeline-mode))

;; Centaur tabs
(use-package centaur-tabs
	:defer t
	:ensure t
	:demand
	:bind
	("C-S-h" . centaur-tabs-backward)
	("C-S-l" . centaur-tabs-forward)
	:config
	(centaur-tabs-mode t)
	(centaur-tabs-headline-match)
	:custom
	(centaur-tabs-style "bar")
	(centaur-tabs-set-bar 'over)
	(centaur-tabs-height 20)
	(centaur-tabs-set-icons t)
	(centaur-tabs-icon-type 'nerd-icons)
	(centaur-tabs-show-new-tab-button nil)
	:hook ((dashboard-mode dired-mode) . centaur-tabs-local-mode))

(use-package nerd-icons-dired
	:defer t
	:commands (nerd-icons-dired-mode)
	:ensure t
	:hook (dired-mode . nerd-icons-dired-mode)
	)

(use-package nerd-icons-completion
	:demand t
	:hook
	(marginalia-mode . nerd-icons-completion-marginalia-setup)
	(after-init . nerd-icons-completion-mode))

(use-package whitespace
	:defer t
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\	 [?·])
																 (tab-mark ?\t [?→ ?\t])
																 )
															 ))

(use-package breadcrumb
	:defer t
	:ensure t
	:hook
	(prog-mode . breadcrumb-local-mode)
	:custom
	(breadcrumb-imenu-crumb-separator
	 (concat " "(nerd-icons-mdicon "nf-md-chevron_right") " "))
	(breadcrumb-project-crumb-separator
	 (concat " "(nerd-icons-mdicon "nf-md-chevron_right") " "))
	(breadcrumb-imenu-max-length 0.5)
	(breadcrumb-project-max-length 0.5)
	:preface
	;; Add icons to breadcrumb
	(advice-add #'breadcrumb--format-project-node :around
							(lambda (og p more &rest r)
								"Icon For File"
								(let ((string (apply og p more r)))
									(if (not more)
											(concat (nerd-icons-icon-for-file string)
															" " string)
										(concat (nerd-icons-faicon
														 "nf-fa-folder_open"
														 :face 'breadcrumb-project-crumbs-face)
														" "
														string)))))

	(advice-add #'breadcrumb--format-ipath-node :around
							(lambda (og p more &rest r)
								"Icon for items"
								(let ((string (apply og p more r)))
									(if (not more)
											(concat (nerd-icons-codicon
															 "nf-cod-symbol_field"
															 :face 'breadcrumb-imenu-leaf-face)
															" " string)
										(cond ((string= string "Packages")
													 (concat (nerd-icons-codicon "nf-cod-package" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((string= string "Requires")
													 (concat (nerd-icons-codicon "nf-cod-file_submodule" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((string= string "Method")
													 (concat (nerd-icons-codicon "nf-cod-symbol_method" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((string= string "Class")
													 (concat (nerd-icons-codicon "nf-cod-symbol_class" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((string= string "Field")
													 (concat (nerd-icons-codicon "nf-cod-symbol_field" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((string= string "Module")
													 (concat (nerd-icons-codicon "nf-cod-package" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((or (string= string "Variable") (string= string "Variables"))
													 (concat (nerd-icons-codicon "nf-cod-symbol_variable" :face 'breadcrumb-imenu-crumbs-face) " " string))
													((string= string "Function")
													 (concat (nerd-icons-codicon "nf-cod-symbol_field" :face 'breadcrumb-imenu-crumbs-face) " " string))
													(t string)))))))

(use-package eshell-starship
	:vc (:url "https://github.com/siddharthverma314/eshell-starship.git"
						:branch "main")
  :config
  (eshell-starship-setup))

;; Configurations for graphic mode
(when (display-graphic-p)
	(set-face-attribute 'default nil
											:font "JetBrainsMono Nerd Font Mono"
											:height 110))

;; Enable mouse on terminal
(unless (display-graphic-p)
	(xterm-mouse-mode t))

;; Resizing a frame rounds its sizes to the frame's
(setq frame-resize-pixelwise t)

;; Show relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(dolist (mode '(eshell-mode-hook dired-mode-hook treemacs-mode-hook lsp-ui-imenu-mode-hook image-mode-hook doc-view-mode-hook))
	(add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Enable current line highlithing
(global-hl-line-mode t)

;; Show current line number
(column-number-mode t)

;; Simplify message yes or no p
(fset 'yes-or-no-p 'y-or-n-p)

;; Disable cursor blinking
(blink-cursor-mode 0)

;; Enable which key
(which-key-mode)

;; Define tab width
(setq-default indent-tabs-mode t
							standard-indent 2
							tab-width 2
							backward-delete-char-untabify-method nil
							)

(provide 'ui-cfg)
