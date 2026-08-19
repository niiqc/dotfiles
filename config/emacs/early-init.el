;; -*- lexical-binding: t; -*-

(setq gc-cons-threshold most-positive-fixnum
			gc-cons-percentage 0.6
			read-process-output-max (* 5 1024 1024))

(add-hook 'emacs-startup-hook
					(lambda () (setq gc-cons-threshold (* 100 1024 1024)
													 gc-cons-percentage 0.1)))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(provide 'early-init)
