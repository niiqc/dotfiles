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
	(setopt modus-themes-mixed-fonts nil
					modus-themes-italic-constructs t)
 	(modus-themes-load-theme 'ef-night))

(use-package nerd-icons
	:ensure t
	:custom
	(nerd-icons-font-family "JetBrainsMono Nerd Font Mono"))

;; Dashboard configuration
(use-package dashboard
	:ensure t
	:custom
	(dashboard-banner-logo-title "Welcome to Emacs!")
	(dashboard-startup-banner (locate-user-emacs-file "banner.txt"))
	(dashboard-icon-type 'nerd-icons)
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
	(doom-modeline-buffer-file-name-style 'project)
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

(use-package ibuffer
	:ensure nil
	:defer t
	:config
	:bind
	(:map ibuffer-name-map
				("<mouse-1>" . ibuffer-visit-buffer))
	:custom
	(ibuffer-saved-filter-groups
	 '(("my/custom-default"
			("Code" (derived-mode . prog-mode))
			("Conf" (derived-mode . conf-mode))
			("Markup" (or (mode . org-mode)
										(derived-mode . markdown-mode)))
			("Shell" (mode . eshell-mode))
			("Directories" (mode . dired-mode))
			("Git" (or (derived-mode . magit-mode)
								 (mode . vc-compilation-mode))))))
	(ibuffer-show-empty-filter-groups nil)
	:hook
	(ibuffer-mode . (lambda ()
										(ibuffer-switch-to-saved-filter-groups "my/custom-default"))))

(use-package nerd-icons-ibuffer
	:ensure t
	:hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package whitespace
	:defer t
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\  [?·])
																 (tab-mark ?\t [?→ ?\t])))
	:ensure nil)

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
	:ensure t)

;; Configurations for graphic mode
(when (display-graphic-p)
	(set-face-attribute 'default nil
											:font "JetBrainsMono Nerd Font Mono"
											:height 140))

;; Resizing a frame rounds its sizes to the frame's
(setopt frame-resize-pixelwise t

				;; Show relative line numbers
				display-line-numbers-type 'relative

				;; Use bar cursor shape
				cursor-type 'bar)


;; Global line numbers
(global-display-line-numbers-mode)

;; Disable line numbers in specific modes
(dolist (mode '(eshell-mode-hook dired-mode-hook image-mode-hook doc-view-mode-hook))
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

(provide 'ui-cfg)
