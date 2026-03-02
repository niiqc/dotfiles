;; -*- lexical-binding: t; -*-

(use-package general
	:ensure t)

(general-create-definer my/leader-key-def
	:keymaps '(normal visual emacs)
	:prefix "SPC"
	:global-prefix "C-SPC")

(my/leader-key-def
	;; Arquivos
	"f"		'(:ignore t :which-key "files")
	"ff"	'(find-file :which-key "find file")
	"fs"	'(save-buffer :which-key "save file")

	;; Buffers
	"b"		'(:ignore t :which-key "buffers")
	"bb"	'(switch-to-buffer :which-key "switch buffer")
	"bd"	'(kill-current-buffer :which-key "kill buffer")
	"ba"	'(centaur-tabs-kill-other-buffers-in-current-group :which-key "kill other buffers")
	"bc"	'(consult-buffer :which-key "change tab group")

	;; Quit
	"q"		'(:ignore t :which-key "quit")
	"qq"	'(save-buffers-kill-emacs :which-key "quit Emacs")

	;; Agenda
	"a"		'(:ignore t :which-key "agenda" )
	"aa"	'(org-agenda :which-key "org-agenda" ov)

	;; Outros
	"h"		'(:ignore t :which-key "help")
	"hf"	'(describe-function :which-key "describe function")
	"hv"	'(describe-variable :which-key "describe variable")
	"ha"	'(apropos :which-key "apropos")

	;; Windows management
	"w"		'(:ignore t :which-key "windows")
	"wh"	'(split-window-below :which-key "split horizontal")
	"wv"	'(split-window-right :which-key "split vertical")
	"wd"	'(delete-window :which-key "delete window")
	"wo"	'(delete-other-windows :which-key "delete other windows")

	;; writeroom-mode
	"z"		'(:ignore t :which-key "writeroom-mode")
	"zw"	'(writeroom-mode :which-key "enable writeroom-mode")

	;; Search project
	"s" '(:ignore t :which-key "Search opts")
	"sp" '(consult-ripgrep :which-key "Search in project")
	)

(general-define-key
 :keymaps 'override
 "C-h"		'windmove-left
 "C-l"		'windmove-right
 "C-j"		'windmove-down
 "C-k"		'windmove-up)

;; TODO: Remove from keybinds
(use-package dtrt-indent
	:custom
	(dtrt-indent-verbosity 0)
	(dtrt-indent-run-after-smie t)
	:ensure t
	:hook (prog-mode . dtrt-indent-mode)
	)

;; TODO: Remove from keybinds and fix tabs
(setq-default indent-tabs-mode t
							standard-indent 2)

(provide 'keybinds-cfg)
