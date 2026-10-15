;; -*- lexical-binding: t; -*-

(use-package org
	:defer t
	:ensure t
	:custom
	(org-startup-indented t)
	(org-src-tab-acts-natively t)
	(org-src-fontify-natively t)
	(org-directory "~/OneDrive/org")
	:hook (org-mode .	(lambda ()
											 (setq-local visual-line-move-text t)
											 (display-fill-column-indicator-mode 1)))
	:config
	(setopt org-ellipsis " ⤵"
					org-pretty-entities	t
					org-fontify-whole-heading-line t
					org-fontify-done-headline t
					org-fontify-quote-and-verse-blocks t
					org-src-preserve-indentation t))
	;; (org-babel-do-load-languages
	;;  'org-babel-load-languages
	;;  '((python-ts-mode . t))))

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

(use-package htmlize
	:ensure t
	:defer t)

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
