;; -*- lexical-binding: t; -*-

(use-package ef-themes
	:ensure t
	:init
	(ef-themes-take-over-modus-themes-mode 1)
	:bind
	(("<f5>" . modus-themes-rotate)
	 ("C-<f5>" . modus-themes-select)
	 ("M-<f5>" . modus-themes-load-random))
	:config
	(setq modus-themes-mixed-fonts t)
	(setq modus-themes-italic-constructs t)
	(modus-themes-load-theme 'ef-night))

(use-package nerd-icons
	:ensure t
	:custom
	(nerd-icons-font-family "JetBrainsMono Nerd Font Mono"))

;; Dashboard configuration
(use-package dashboard
	:ensure t
	:custom
	(initial-buffer-choice 'dashboard-open)
	(dashboard-startupify-list '(dashboard-insert-banner
															 dashboard-insert-newline
															 dashboard-insert-banner-title
															 dashboard-insert-newline
															 dashboard-insert-navigator
															 dashboard-insert-newline
															 dashboard-insert-init-info
															 dashboard-insert-items
															 dashboard-insert-newline
															 dashboard-insert-footer))
	(dashboard-navigator-buttons
	 `(
		 ((,(nerd-icons-devicon "nf-dev-git" :height 1.1 :v-adjust 0.0)
			 ""
			 "Browse homepage"
			 (lambda (&rest _) (browse-url "https://codeberg.org/niqc")))
			(,(nerd-icons-mdicon "nf-md-refresh" :height 1.1 :v-adjust 0.0)
			 ""
			 "Clear zombie items from recents and projects"
			 (lambda (&rest _)
				 (recentf-cleanup)
				 (project-forget-zombie-projects)
				 (message "Clear!")
				 ))
			)))
	(dashboard-banner-logo-title "Welcome to Emacs!")
	(dashboard-startup-banner (locate-user-emacs-file "banner.txt"))
	(dashboard-icon-type 'nerd-icons)
	(dashboard-navigation-cycle t)
	(dashboard-set-heading-icons t)
	(dashboard-set-file-icons t)
	(dashboard-vertically-center-content t)
	(dashboard-center-content t)
	(dashboard-items '((recents		. 5)
										 (projects	. 5)))
	:init
	(dashboard-setup-startup-hook))

(use-package doom-modeline
	:defer t
	:custom
	(doom-modeline-indent-info t)
	(doom-modeline-height 25)
	(auto-revert-check-vc-info t)
	(doom-modeline-vcs-max-length 25)
	(doom-modeline-major-mode-icon nil)
	(doom-modeline-bar-width 4)
	(doom-modeline-buffer-file-name-style 'file-name-with-project)
	:ensure t
	:hook (after-init . doom-modeline-mode))

(use-package nerd-icons-dired
	:defer t
	:commands (nerd-icons-dired-mode)
	:ensure t
	:hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
	:ensure t
	:demand t
	:hook
	(marginalia-mode . nerd-icons-completion-marginalia-setup)
	(after-init . nerd-icons-completion-mode))

(use-package nerd-icons-ibuffer
	:ensure t
	:hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package whitespace
	:defer t
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\	 [?·])
																 (tab-mark ?\t [?→ ?\t])
																 )
															 ))

;; Diff-hl
(use-package diff-hl
	:ensure t
	:custom
	(diff-hl-update-async t)
	(vc-git-diff-switches '("--histogram"))
	(diff-hl-flydiff-delay 0.5)
	(diff-hl-show-staged-changes nil)
	:config
	(diff-hl-flydiff-mode)
	:hook ((magit-post-refresh	. diff-hl-magit-post-refresh)
				 (vc-checkin					. diff-hl-update)
				 (dired-mode					. diff-hl-dired-mode))
	:init (global-diff-hl-mode))

(use-package indent-bars
	:hook (prog-mode . (lambda () (indent-bars-mode 1)))
	:custom
	(indent-bars-treesit-support t)
	(indent-bars-treesit-wrap '((python argument_list parameters
																			list list_comprehension
																			dictionary dictionary_comprehension
																			parenthesized_expression subscript)
															(toml table array comment)
															(yaml block_mapping_pair comment)
															(rust arguments parameters)
															(c argument_list parameter_list init_declarator parenthesized_expression)))
	(indent-bars-treesit-scope '((rust trait_item impl_item
																		 macro_definition macro_invocation
																		 struct_item enum_item mod_item
																		 const_item let_declaration
																		 function_item for_expression
																		 if_expression loop_expression
																		 while_expression match_expression
																		 match_arm call_expression
																		 token_tree token_tree_pattern
																		 token_repetition)))
	(indent-bars-treesit-ignore-blank-lines-types '("module"))
	(indent-bars-color '(highlight :face-bg t :blend 0.15))
	(indent-bars-pattern ".")
	(indent-bars-width-frac 0.1)
	(indent-bars-pad-frac 0.1)
	(indent-bars-zigzag nil)
	(indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1)) ; blend=1: blend with BG only
	(indent-bars-highlight-current-depth '(:blend 0.5)) ; pump up the BG blend on current
	(indent-bars-display-on-blank-lines t)
	(indent-bars-starting-column 0)
	:ensure t)

(use-package breadcrumb
	:config (breadcrumb-mode t)
	:custom
	(breadcrumb-imenu-crumb-separator " > ")
	(breadcrumb-project-crumb-separator " > ")
	:ensure t)

;; Configurations for graphic mode
(when (display-graphic-p)
	(set-face-attribute 'default nil
											:font "JetBrainsMono Nerd Font Mono"
											:height 120))

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
