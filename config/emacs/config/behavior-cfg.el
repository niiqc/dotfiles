;; Emacs auto-save
(add-hook 'emacs-lisp-mode-hook
					(lambda ()
						(add-hook 'before-save-hook (lambda () (indent-region (point-min) (point-max))) nil t)
						))

;; use editorconfig from project
(editorconfig-mode t)

;; Remove white space from end of file
(add-hook 'before-save-hook #'whitespace-cleanup)

;; Show cursor only on focus
(setq-default cursor-in-non-selected-windows nil)

;; Remove two spaces from end of sentence
(setq-default sentence-end-double-space nil)

(global-subword-mode 1)

;; Move to trash
(setq delete-by-moving-to-trash t)

;; Increase undo limit
(setq undo-limit 100000000
			auto-save-default t)

;; Take new window space from all other windows
(setq window-combination-resize t)

;; Fill all real char
(setq x-stretch-cursor t)

;; ellipsis on truncated text
;; FIXME: Truncate ellipsis not working
(with-eval-after-load 'mule-util
	(setq truncate-string-ellipsis " ⤵"))

;; Scroll step
(setq scroll-step 1
			scroll-conservatively 10000)

(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

;; Not create bkp/lockfiles
;; TODO: Remove from behavior file
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(auto-save-mode nil)

;; Remove subtitle legend on press one key
(setq echo-keystrokes 0)

;; Disable Tooltips
;; TODO: Remove from behavior
(setq x-gtk-use-system-tooltips nil)
(setq use-system-tooltips nil)

;; Set utf enconding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)

;; Disable Tooltips
(setq x-gtk-use-system-tooltips nil)
(setq use-system-tooltips nil)

;; Enable hs-minor-mode on prog mode
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; Add other files to identity a project
(setq project-vc-extra-root-markers '(".dir-locals.el"))

;; Make clipboard works on wayland terminal
(when (executable-find "wl-copy")
	(defun wl-copy (text)
		(let ((p (make-process :name "wl-copy" :command '("wl-copy") :connection-type 'pipe)))
			(process-send-string p text)
			(process-send-eof p)))
	(setq interprogram-cut-function 'wl-copy))

(when (executable-find "wl-paste")
	(defun wl-paste ()
		(shell-command-to-string "wl-paste"))
	(setq interprogram-paste-function 'wl-paste))

;; Evil configuration
(defun vim-dec-inc-delta (delta)
	(interactive "p")
	(skip-chars-backward "0-9-")
	(if (looking-at "-?[0-9]+")
			(let* ((old (match-string 0))
						 (new (number-to-string (+ (string-to-number old) delta))))
				(replace-match new t) ;; substitui e move para depois do número
				(backward-char 1)) ;; volta 1 caractere para ficar no último dígito
		(error "No number at point")))

(global-set-key (kbd "C-a") (lambda () (interactive) (vim-dec-inc-delta 1)))
(global-set-key (kbd "C-S-x") (lambda () (interactive) (vim-dec-inc-delta -1)))

;; Evil configuration
(use-package evil
	:init
	(setq evil-want-keybinding nil)
	(setq evil-want-integration t)
	:ensure t
	:config
	(evil-mode 1)
	:custom
	(evil-want-C-u-scroll t)
	(evil-kill-on-visual-paste nil))

(use-package evil-collection
	:ensure t
	:after evil
	:config
	(evil-collection-init))

(use-package evil-goggles
	:after evil
	:ensure t
	:custom
	(evil-goggles-use-diff-faces)
	:config
	(evil-goggles-mode))

(use-package evil-nerd-commenter
	:ensure t
	:config
	(evilnc-default-hotkeys))

(use-package evil-terminal-cursor-changer
	:ensure t
	:unless (display-graphic-p)
	:after evil
	:config
	(evil-terminal-cursor-changer-activate))

(use-package corfu
	:ensure t
	:init (global-corfu-mode)
	(corfu-popupinfo-mode 1)
	:custom
	(corfu-auto t)
	(corfu-auto-prefix 1)
	(corfu-auto-delay 0.1)
	(corfu-cycle t)
	(corfu-separator ?\s)
	(corfu-quit-no-match 'separator)
	(corfu-preview-current 'insert)
	(corfu-preselect-first t)
	(corfu-popupinfo-max-width 80)
	(corfu-popupinfo-max-height 14)
	(corfu-popupinfo-resize t)
	(corfu-popupinfo-direction '(right vertical left)))

;; TODO: Install local plugin - corfu terminal
;; (use-package corfu-mouse
;;	 :load-path "~/.config/emacs/emacs-local-plugins/corfu-terminal"
;;	 :config
;;	 (if (display-graphic-p)
;;			 (corfu-mouse-mode 1)))

;; (use-package corfu-terminal
;;	 :load-path "~/.config/emacs/emacs-local-plugins/corfu-terminal"
;;	 :config
;;	 (unless (display-graphic-p)
;;		 (corfu-terminal-mode +1)))


(use-package emacs
	:custom
	(window-sides-vertical t)
	)

(use-package nerd-icons-corfu
	:after corfu
	:config (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
	:ensure t)

(defun my/eglot-capf ()
	(setq-local completion-at-point-functions
							(list (cape-capf-super
										 #'eglot-completion-at-point
										 #'cape-dabbrev
										 #'cape-file
										 #'cape-keyword
										 ))))

(use-package cape
	:ensure t
	:config (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
	:custom
	(completion-category-overrides '((eglot (styles orderless))
                                   (eglot-capf (styles orderless))))
	:hook (eglot-managed-mode . my/eglot-capf)
	:init
	;; Add `completion-at-point-functions', used by `completion-at-point'.
	(setq-default completion-at-point-functions
								(append (default-value 'completion-at-point-functions)
												(list #'cape-dabbrev #'cape-file #'cape-abbrev #'cape-tex #'cape-dict #'cape-elisp-block
															#'cape-elisp-symbol #'cape-keyword #'cape-history))))

;; Enable Vertico.
(use-package vertico
	:defer t
	:ensure t
	:config
	(vertico-mouse-mode)
	:custom
	(vertico-scroll-margin 0) ;; Different scroll margin
	(vertico-count 20) ;; Show more candidates
	(vertico-resize t) ;; Grow and shrink the Vertico minibuffer
	(vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
	:init
	(vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
	:ensure nil
	:init
	(savehist-mode))

(use-package orderless
	:ensure t
	:init
	(setq completion-styles '(orderless basic))
	(setq completion-category-defaults nil)
	(setq completion-category-overrides
				'((file (styles partial-completion)))))


;; Marginalia
(use-package marginalia
	:ensure t
	:init
	(marginalia-mode))

;; Nerd icons for minibuffer
(use-package nerd-icons-completion
	:ensure t
	:after marginalia
	:config
	(nerd-icons-completion-mode)
	(add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package consult
	:defer t
	:ensure t)

(use-package embark
	:ensure t
	:init
	(setq prefix-help-command #'embark-prefix-help-command)
	:config
	(add-to-list 'display-buffer-alist
							 '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
								 nil
								 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
	:defer t
	:ensure t
	:hook
	(embark-collect-mode . consult-preview-at-point-mode))

(use-package gt
	:bind (("C-x C-t " . gt-setup))
	:defer t
	:ensure t
	:config
	(setq gt-default-translator (gt-translator :engines (gt-google-engine)))
	(setq gt-preset-translators
				`((en-pt . ,(gt-translator
										 :taker (gt-taker :langs '(en pt) :text 'word)
										 :engines (gt-google-engine)
										 :render (gt-posframe-pop-render)))
					(pt-en . , (gt-translator
											:taker (gt-taker :langs '(pt en) :text 'word)
											:engines (gt-google-engine)
											:render (gt-overlay-render)
											))
					)))

(use-package treesit-auto
	:config
	(global-treesit-auto-mode)
	;; Define itens to install
	(dolist (lang '(bash c cpp css dockerfile html json lua python rust yaml tsx typescript javascript))
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
					(tsx				. ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
					(typescript	. ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
					(javascript	. ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
					))
	:ensure t
	)

(use-package csv-mode
	:defer t
	:ensure t)

(provide 'behavior-cfg)

;;; behavior-cfg.el ends here
