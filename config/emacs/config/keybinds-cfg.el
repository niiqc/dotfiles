;;; com-keybinds.el --- keyboard behavior	 -*- lexical-binding: t; -*-

;; Copyright (C) 2025
;; SPDX-License-Identifier: GPL-3.0-or-later

;; Author: nick

;;; Commentary:

;; Define keybinds like vim

;;; Code:

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

	;; Projetos
	"p"		'(:ignore t :which-key "projects")
	"pp"	'(projectile-switch-project :which-key "switch project")
	"pf"	'(projectile-find-file :which-key "find file in project")

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

	;; Treemacs
	;; "t"		'(:ignore t :which-key "treemacs")
	;; "tt"	'(treemacs :which-key "toggle treemacs")

	"t"		'(:ignore t :which-key "treemacs")
	"tt"	'(dirvish-side :which-key "toggle treemacs")



	;; Flycheck
	"e"		'(:ignore t :which-key "errors")
	"el"	'(flycheck-list-errors :which-key "list errors")
	"en"	'(flycheck-next-error :which-key "next error")
	"ep"	'(flycheck-previous-error :which-key "previous error")
	"ev"	'(flycheck-verify-setup :which-key "verify setup")
	"eb"	'(flycheck-buffer :which-key "check buffer")

	;; Lsp
	"l"		'(:ignore t :which-key "lsp")
	"la"	'(lsp-execute-code-action :which-key "code action")
	"lA"	'(lsp-ui-sideline-apply-code-actions :which-key "apply sideline action")

	;; Windows management
	"w"		'(:ignore t :which-key "windows")
	"wh"	'(split-window-below :which-key "split horizontal")
	"wv"	'(split-window-right :which-key "split vertical")
	"wd"	'(delete-window :which-key "delete window")
	"wo"	'(delete-other-windows :which-key "delete other windows")

	;; writeroom-mode
	"z"		'(:ignore t :which-key "writeroom-mode")
	"zw"	'(writeroom-mode :which-key "enable writeroom-mode")

	;; Ui
	"u"		'(:ignore t :which-key "ui settings")
	"umt"	'(imenu-list-smart-toggle :which-key "toggle imenu list")

	;; Search project
	"s" '(:ignore t :which-key "Search opts")
	"sp" '(consult-ripgrep :which-key "Search in project")
	"SPC" '(projectile-find-file :which-key "find files in the project")


	;; Debugger
	"db"	'(dap-breakpoint-toggle :which-key "toggle dap breakpoint")
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
;;; com-keybinds.el ends here
