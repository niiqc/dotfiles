;; -*- lexical-binding: t; -*-

(use-package org
	:defer t
	:ensure t
	:custom
	(org-startup-indented t)
	(org-src-tab-acts-natively t)
	(org-src-fontify-natively t)
	:hook (org-mode .	 (lambda ()
											 (visual-line-mode 1)
											 (setq-local visual-line-move-text t)
											 (setq-local fill-column 100)
											 (display-fill-column-indicator-mode 1)))
	:config
	(setq org-ellipsis												 "	 ⤵"
				org-pretty-entities									 t
				org-fontify-whole-heading-line			 t
				org-fontify-done-headline						 t
				org-fontify-quote-and-verse-blocks	 t
				org-src-preserve-indentation				 t
				)
	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((mermaid . t))))

(use-package evil-org
	:defer t
	:ensure t
	:after org
	:hook (org-mode . evil-org-mode)
	:config
	(require 'evil-org-agenda)
	(evil-org-agenda-set-keys))

;; Roam
(use-package websocket
	:ensure t
	:after org-roam)

(use-package org-roam-ui
	:ensure t
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package org-roam
	:defer t
	:after org
	:ensure t
	:config
	(org-roam-db-autosync-mode)
	(add-to-list 'display-buffer-alist
							 '("\\*org-roam\\*"
								 (display-buffer-in-direction)
								 (direction . right)
								 (window-width . 0.33)
								 (window-height . fit-window-to-buffer)))
	:custom
	(find-file-visit-truename t)
	(org-roam-directory (file-truename "~/Documents/org"))
	:bind (("C-c n l" . org-roam-buffer-toggle)
				 ("C-c n f" . org-roam-node-find)
				 ("C-c n g" . org-roam-graph)
				 ("C-c n i" . org-roam-node-insert)
				 ("C-c n c" . org-roam-capture)
				 ;; Dailies
				 ("C-c n j" . org-roam-dailies-capture-today)))

(use-package org-dt
	:ensure t
	:after org-roam
	:config
	(advice-add 'org-roam-capture :before #'org-dt-load-templates)
	(defun my/ask-dir ()
		(concat (read-directory-name "Directory: " default-directory)))
	:custom
	(org-dt-using-roam t)
	(org-dt-capture-target "%(concat (my/ask-dir) \"/\" \"${slug}.org\")")
  :vc (:url "https://codeberg.org/niqc/org-dynamic-templates.git"
						:rev :newest
            :branch "main"))

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
