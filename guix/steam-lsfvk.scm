(use-modules (guix profiles)
						 (gnu packages gl) ; mesa
						 (nonguix multiarch-container) ; nonguix-container, fhs-union
						 (nongnu packages game-client)
						 (tuco packages games)) ; lsfg-vk

(define base (steam-container-for mesa))

(define steam-lsfg
	(nonguix-container->package
	 (nonguix-container
		(inherit base)
		(union64
		 (fhs-union `(,@(@@ (nongnu packages game-client) steam-container-libs)
									("lsfg-vk" ,lsfg-vk))
								#:name "fhs-union-64")))))

(packages->manifest (list steam-lsfg))
