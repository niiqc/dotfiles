;; -*- lexical-binding: t; -*-

;; Navigation
(define-prefix-command 'my/window-map)
(global-set-key (kbd "C-c w") 'my/window-map)

(define-key my/window-map (kbd "h") #'split-window-below)
(define-key my/window-map (kbd "v") #'split-window-right)
(define-key my/window-map (kbd "d") #'delete-window)

(global-set-key (kbd "<next>") (lambda () (interactive) (vertical-motion 20)))
(global-set-key (kbd "<prior>") (lambda () (interactive) (vertical-motion -20)))

(global-set-key (kbd "C-<next>") (lambda () (interactive) (scroll-up-command)))
(global-set-key (kbd "C-<prior>") (lambda () (interactive) (scroll-down-command)))

(global-set-key (kbd "C-_") 'undo-only)

(global-set-key (kbd "C-,") 'my/duplicate-line)

(global-set-key (kbd "C-c s") 'my/expand-region)

(windmove-default-keybindings 'control)
(global-set-key [remap list-buffers] 'ibuffer)
(global-set-key [remap project-list-buffers] 'my/project-ibuffer)

(use-package dtrt-indent
	:custom
	(dtrt-indent-verbosity 0)
	(dtrt-indent-run-after-smie t)
	:ensure t
	:hook (prog-mode . dtrt-indent-mode))

(use-package multiple-cursors
	:bind
	("C->"			. mc/mark-next-like-this)
	("C-<"			. mc/mark-previous-like-this)
	("C-c C-<"	. mc/mark-all-like-this)
	("C-\""			. mc/skip-to-next-like-this)
	("C-:"			. mc/skip-to-previous-like-this)
	:defer t
	:ensure t)

(setq-default indent-tabs-mode t
							standard-indent 2)

(provide 'keybinds-cfg)
