;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (locate-user-emacs-file "lisp/")) 

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

(require 'repos-cfg)
(require 'ui-cfg)
(require 'behavior-cfg)
(require 'code-cfg)
(require 'keybinds-cfg)
(require 'org-cfg)

(provide 'init)

