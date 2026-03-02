(use-modules (guix profiles)
						 (gnu packages emacs) ;; emacs
						 (gnu packages version-control) ;; git
						 (gnu packages python) ;; python-next
						 (gnu packages rust-apps) ;; uv, ripgrep
						 (gnu packages tex) ;; texlive
						 (gnu packages guile) ;; guile-next
						 (gnu packages guile-xyz) ;; guile-goblins
						 (gnu packages haskell-xyz) ;; pandoc
						 (gnu packages nss) ;; nss certs
						 )

(define (base-pkgs)
	(list git emacs-next nss-certs ripgrep)
	)

(define (guile-dev)
	(list guile-next guile-goblins)
	)

(define (python-dev)
	(list python-next uv)
	)

(define (docs)
	(list
	 pandoc
	 texlive-collection-latexrecommended
	 texlive-wrapfig
	 texlive-ulem
	 texlive-capt-of
	 texlive-titling
	 texlive-hyphenat
	 texlive-titlesec
	 texlive-enumitem
	 )
	)

(packages->manifest
 (append (base-pkgs)
				 (guile-dev)
				 (python-dev)
				 (docs)
				 )
 )
