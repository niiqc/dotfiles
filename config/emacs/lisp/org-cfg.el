;; -*- lexical-binding: t; -*-

(use-package org
	:defer t
	:ensure t
	:custom
	(org-startup-indented t)
	(org-src-tab-acts-natively t)
	(org-src-fontify-natively t)
	:hook (org-mode .	 (lambda ()
											 (setq-local visual-line-move-text t)
											 (setq-local fill-column 100)
											 (display-fill-column-indicator-mode 1)))
	:config
	(setq org-ellipsis " ⤵"
				org-pretty-entities	t
				org-fontify-whole-heading-line t
				org-fontify-done-headline t
				org-fontify-quote-and-verse-blocks t
				org-src-preserve-indentation t)
	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((mermaid . t))))

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
	(org-dt-capture-target "%(concat (my/ask-dir) \"/\" \"${title}.org\")"))

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
	:after org)

(use-package outline-mode
	:custom
	(outline-minor-mode-use-buttons 'in-margins)
	(outline-overlay-button-map nil)
	:ensure nil
	:hook (org-mode . outline-minor-mode))

(use-package org-modern
	:after org
	:custom
	(org-modern-star nil)
	(org-modern-list nil)
	(org-modern-star 'replace)
	(org-modern-replace-stars "αβγδ")
  (org-modern-list
   '((?+ . "➤")
     (?- . "–")
     (?* . "•")))
  (org-modern-priority
   '((?A . "⚑")
     (?B . "⬆")
     (?C . "⬇")))
	:ensure t)

(use-package org-modern-indent
	:after org-modern
	:hook (org-modern-mode . org-modern-indent-init)
	:vc (:url "https://github.com/jdtsmith/org-modern-indent" :branch "main"))

;; Create toggle for "preview" org modern
(with-eval-after-load 'org
	(setq org-preview-enable nil)

	(defun my/toggle-org-preview ()
		(interactive)
		(org-modern-mode 'toggle)
		(org-modern-indent-mode 'toggle)
		(if org-preview-enable
				(setq-local org-preview-enable nil)
			(setq-local org-preview-enable t)))

	(define-key org-mode-map (kbd "C-c o p") #'my/toggle-org-preview))

(with-eval-after-load 'doom-modeline
	(doom-modeline-def-segment my/org-modern-preview-segment
		(when (derived-mode-p 'org-mode)
			(let* ((face (if org-preview-enable 'nerd-icons-green 'nerd-icons-red))
						 (icon (nerd-icons-sucicon "nf-custom-orgmode" :face face))
						 (full-text (concat icon (format " %s" (if org-preview-enable "on" "off")))))
				(propertize full-text
									'face face
                  'help-echo "Toggle org modern preview"
                  'mouse-face 'mode-line-highlight
                  'local-map (make-mode-line-mouse-map
                              'mouse-1 'my/toggle-org-preview)))))

	(doom-modeline-add-segment 'my/org-modern-preview-segment 'indent-info :before))

(provide 'org-cfg)
