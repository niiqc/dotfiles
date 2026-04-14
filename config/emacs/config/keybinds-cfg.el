;; -*- lexical-binding: t; -*-

;; Navigation
(define-prefix-command 'my/window-map)
(global-set-key (kbd "C-c w") 'my/window-map)

(define-key my/window-map (kbd "h") #'split-window-below)
(define-key my/window-map (kbd "v") #'split-window-right)
(define-key my/window-map (kbd "d") #'delete-window)

(windmove-default-keybindings 'control)

(global-set-key [remap list-buffers] 'ibuffer)

(use-package dtrt-indent
	:custom
	(dtrt-indent-verbosity 0)
	(dtrt-indent-run-after-smie t)
	:ensure t
	:hook (prog-mode . dtrt-indent-mode)
	)

(setq-default indent-tabs-mode t
							standard-indent 2)

(provide 'keybinds-cfg)
