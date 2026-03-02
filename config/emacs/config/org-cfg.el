;; -*- lexical-binding: t; -*-

;; TODO: (Install org indent mode local plugin) - after install org-modern indent uncomment this lines
(use-package org
	:defer t
	:ensure t
	;; :hook (org-mode .	org-indent-mode)
	:custom
	(org-startup-indented t)
	(org-src-tab-acts-natively t)
	;; (org-edit-src-content-indentation 0)
	(org-src-fontify-natively t)
	:hook (org-mode .	 (lambda ()
											 (visual-line-mode 1)
											 (setq-local visual-line-move-text t)
											 (setq-local fill-column 100)
											 (display-fill-column-indicator-mode 1)))
	:config
	(setq org-ellipsis												 "	 ⤵"
				org-redisplay-inline-images					 t
				org-display-inline-images						 t
				org-startup-with-inline-images			 "inlineimages"
				;; org-image-actual-width							 300
				org-pretty-entities									 t
				org-fontify-whole-heading-line			 t
				org-fontify-done-headline						 t
				org-fontify-quote-and-verse-blocks	 t
				org-src-preserve-indentation				 t
				)
	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((mermaid . t))))

;; TODO: (section evil) change it to behavior
(use-package evil-org
	:defer t
	:ensure t
	:after org
	:hook (org-mode . evil-org-mode)
	:config
	(require 'evil-org-agenda)
	(evil-org-agenda-set-keys))

;; Modify behavior according to evil mode
;; Enable / disable org rendering
;; (with-eval-after-load 'evil
;;	 (defvar-local my/org-modern-was-enabled nil)

;;	 (defun my/org-modern-save-and-disable ()
;;		 (when (derived-mode-p 'org-mode)
;;			 (setq my/org-modern-was-enabled (bound-and-true-p org-modern-mode))
;;			 (when my/org-modern-was-enabled
;;				 (org-modern-mode -1))))

;;	 (defun my/org-modern-restore-after-insert ()
;;		 (when (derived-mode-p 'org-mode)
;;			 (when my/org-modern-was-enabled
;;				 (org-modern-mode 1)
;;				 (setq my/org-modern-was-enabled nil))))

;;	 (add-hook 'evil-insert-state-entry-hook #'my/org-modern-save-and-disable)
;;	 (add-hook 'evil-insert-state-exit-hook	 #'my/org-modern-restore-after-insert))

;; Org ui
;; (use-package org-modern
;;	:ensure t
;;	:after org
;;	:custom
;;	(org-modern-star 'star)
;;	(org-modern)
;;	(org-modern-replace-stars "αβχδε")
;;	:hook (org-mode . (lambda () (when (display-graphic-p) (org-modern-mode))))
;;	:hook (org-agenda-finalize . org-modern-agenda))

;; (use-package org-bullets
;;	 :ensure t
;;	 :commands org-bullets-mode
;;	 :hook (org-mode . (lambda () (unless (display-graphic-p) (org-bullets-mode)))))

;; (add-hook 'org-mode-hook (lambda ()
;;														(interactive)
;;														(electric-indent-local-mode -1)))

;; TODO: Install org indent mode local plugin
;; (use-package org-modern-indent
;;	 :load-path "~/.config/emacs/emacs-local-plugins/org-modern-indent"
;;	 :config	(add-hook 'org-mode-hook #'org-modern-indent-mode 90))

;; (use-package org-rainbow-tags
;;	 :ensure t
;;	 :custom
;;	 (org-rainbow-tags-hash-start-index 10)
;;	 (org-rainbow-tags-extra-face-attributes
;;		;; Default is '(:weight 'bold)
;;		'(:inverse-video t :box t :weight 'bold))
;;	 :hook
;;	 ((org-mode org-agenda-finalize) . org-rainbow-tags-mode))

;; TODO: think about it
;; (use-package olivetti
;;	:ensure t
;;	:config
;;	:hook (olivetti-mode-on-hook . (lambda () (olivetti-set-width 100))))

;; Mermaid
(use-package ob-mermaid
	:ensure t
	:init
  (add-to-list 'org-src-lang-modes '("mermaid" . mermaid))

	(defun org/update-mmdc ()
		(interactive)
		(shell-command "npm update -g @mermaid-js/mermaid-cli"))

	(unless (executable-find "mmdc")
		(when (executable-find "npm")
			(shell-command "npm install -g @mermaid-js/mermaid-cli")))
	:defer t
	:after org)


(provide 'org-cfg)
