;; -*- lexical-binding: t; -*-

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Improve emacs perfomance
(setq gc-cons-threshold 100000000
			gc-cons-percentage 0.6
			read-process-output-max 1048576
			native-comp-speed 2

			;; Remove initial tutorial screen and others
			inhibit-startup-screen t
			inhibit-splash-screen t
			inhibit-startup-message t
			inhibit-startup-buffer-menu t)
