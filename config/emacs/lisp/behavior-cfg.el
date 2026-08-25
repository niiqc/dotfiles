;; -*- lexical-binding: t; -*-

;; Not create bkp/lockfiles
(setopt auto-save-default nil
				create-lockfiles nil
				make-backup-files nil
				auto-save-visited-interval 1

				;; Remove save message
				save-silently t

				;; Remove two spaces from end of sentence
				sentence-end-double-space nil

				;; Show cursor only on focus
				cursor-in-non-selected-windows nil

				;; Scroll step
				scroll-step 1
				scroll-conservatively 10000
				mouse-wheel-scroll-amount '(3 ((shift) . hscroll) ((meta)) ((control meta) . global-text-scale)
																			((control) . text-scale))

				mouse-wheel-progressive-speed nil

				;; Remove subtitle legend on press one key
				echo-keystrokes 0

				;; Disable Tooltips
				x-gtk-use-system-tooltips nil
				use-system-tooltips nil

				;; Add other files to identity a project
				project-vc-extra-root-markers '(".dir-locals.el")

				;; Move to trash
				delete-by-moving-to-trash t

				;; Increase undo limit
				undo-limit 100000000

				;; Take new window space from all other windows
				window-combination-resize t

				;; Fill all real char
				x-stretch-cursor t)

;; use editorconfig from project
(editorconfig-mode t)

;; Enable auto save
(auto-save-visited-mode 1)

;; Set utf enconding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)

;; Duplicate current line, at same point
(defun my/duplicate-line ()
	"Duplicate current line"
	(interactive)
	(let ((column (- (point) (point-at-bol)))
				(line (let ((s (thing-at-point 'line t)))
								(if s (string-remove-suffix "\n" s) ""))))
		(move-end-of-line 1)
		(newline)
		(insert line)
		(move-beginning-of-line 1)
		(forward-char column)))

;; Function to expand region from cursor
(defun my/expand-region (&optional fchar echar)
	(interactive)
	(let* ((fchar (or fchar (char-to-string (read-char "start char: "))))
				 (echar (or echar (char-to-string (read-char "end char: "))))
				 (origin (point)))
		(if (and (search-backward fchar nil t)
						 (progn
							 (goto-char (+ (point) (length fchar)))
							 (set-mark (point))
							 (goto-char origin)
							 (search-forward echar nil t)))
				(goto-char (- (point) (length echar)))
			(deactivate-mark)
			(goto-char origin)
			(message "Could not find delimiters"))))

;; Make clipboard works on wayland terminal
(when (executable-find "wl-copy")
	(defun wl-copy (text)
		(let ((p (make-process :name "wl-copy" :command '("wl-copy") :connection-type 'pipe)))
			(process-send-string p text)
			(process-send-eof p)))
	(setopt interprogram-cut-function 'wl-copy))

(when (executable-find "wl-paste")
	(defun wl-paste ()
		(shell-command-to-string "wl-paste"))
	(setopt interprogram-paste-function 'wl-paste))

(use-package corfu
	:config (corfu-popupinfo-mode t)
	:custom
	(corfu-auto t)
	(corfu-auto-prefix 1)
	(corfu-auto-delay 0.5)
	(corfu-cycle t)
	(corfu-separator ?\s)
	(corfu-quit-no-match 'separator)
	(corfu-preview-current 'insert)
	(corfu-preselect-first t)
	(corfu-popupinfo-max-width 80)
	(corfu-popupinfo-max-height 14)
	(corfu-popupinfo-resize t)
	(corfu-popupinfo-direction '(right vertical left))
	(corfu-history-mode t)
	:ensure t
	:init
	(global-corfu-mode))

(use-package emacs
	:custom
	(window-sides-vertical t))

(defun my/eglot-capf ()
	(setq-local completion-at-point-functions
							(list (cape-capf-super
										 #'eglot-completion-at-point
										 #'cape-dabbrev
										 #'cape-keyword
										 ))))

(use-package cape
	:bind("C-c p" . cape-prefix-map)
	:ensure t
	:config (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
	:hook (eglot-managed-mode . my/eglot-capf)
	:init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

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
	:custom (savehist-additional-variables '(corfu-history))
	:init
	(savehist-mode))

(use-package orderless
	:ensure t
	:init
	(setopt completion-styles '(orderless basic)
					completion-category-defaults nil
					completion-category-overrides '((file (styles partial-completion))
																					(eglot (styles orderless))
																					(eglot-capf (styles orderless)))))

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
 	:bind (("C-c F" . consult-ripgrep))
	:defer t
	:ensure t)

(use-package gt
	:bind (("C-c t c" . gt-setup)
				 ("C-c t s" . gt-switch-translator)
				 ("C-c t t" . gt-translate))
	:defer t
	:ensure t
	:config
 	;; Temporary solve vertico error on emacs 31
	;; PR is open remove this when pr is merged
	;; https://github.com/lorniu/gt.el/pull/109
	(defun my/gt-fix-category (orig &rest args)
		(let ((res (apply orig args)))
			(lambda (input pred action)
				(if (eq action 'metadata)
						'(metadata (category . gt))
					(funcall res input pred action)))))

	(advice-add 'gt-make-completion-table :around #'my/gt-fix-category)

	(setopt gt-default-translator
					(gt-translator :engines (gt-google-engine)
												 :taker (gt-taker :langs '(en pt) :text 'word)
												 :render (gt-buffer-render))

					gt-preset-translators
					`((en-pt . ,(gt-translator
											 :taker (gt-taker :langs '(en pt) :text 'word)
											 :engines (gt-google-engine)
											 :render (gt-buffer-render)))
						(pt-en . , (gt-translator
												:taker (gt-taker :langs '(pt en) :text 'word)
												:engines (gt-google-engine)
												:render (gt-buffer-render)
												)))))

(use-package treesit
	:config
	(let ((lang-file-alist '((bash            . sh-script)
													 (c               . c-ts-mode)
													 (cpp             . c-ts-mode)
													 (css             . css-mode)
													 (dockerfile      . dockerfile-ts-mode)
													 (elixir          . elixir-ts-mode)
													 (heex            . heex-ts-mode)
													 (html            . html-ts-mode)
													 (json            . json-ts-mode)
													 (lua             . lua-ts-mode)
													 (markdown        . markdown-ts-mode)
													 (markdown-inline . markdown-ts-mode)
													 (python          . python)
													 (rust            . rust-ts-mode)
													 (yaml            . yaml-ts-mode))))
		(mapc (lambda (lang)
						(unless (treesit-language-available-p lang)
							(require (alist-get lang lang-file-alist) nil t)
							(treesit-install-language-grammar lang)))
					(mapcar #'car lang-file-alist)))
	:custom
	(treesit-auto-install-grammar 'always)
	(treesit-enabled-modes t)
	(treesit-font-lock-level 4)
	:ensure nil)

(use-package elec-pair
	:config (electric-pair-mode t)
	:ensure nil)

(use-package move-text
	:bind
	("M-<up>" . move-text-up)
	("M-p" . move-text-up)
	("M-<down>" . move-text-down)
	("M-n" . move-text-down)
	:defer t
	:ensure t)

(use-package dired
	:ensure nil
	:bind
	(:map dired-mode-map
				("<mouse-2>" . dired-mouse-find-file)
				("<mouse-3>" . dired-mouse-find-file-other-window))
	:custom
	;; Set dired default args do be more organized.
	(dired-listing-switches "-al --human-readable --group-directories-first --no-group --dired"))

(use-package csv-mode
	:defer t
	:ensure t)

(provide 'behavior-cfg)

;;; behavior-cfg.el ends here
