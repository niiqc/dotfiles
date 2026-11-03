(define-module (home)
	#:use-module (gnu home)
	#:use-module (gnu home services)
	#:use-module (gnu home services desktop)
	#:use-module (gnu home services gnupg)
	#:use-module (gnu home services shells)
	#:use-module (gnu home services xdg) ; xdg-user-dirs-service-type
	#:use-module (gnu home services sound) ; home-pipewire-service-type
	#:use-module (gnu home services guix) ; guix channels
	#:use-module (gnu home services ssh) ; home-ssh-agent-service-type
	#:use-module (gnu home services shepherd) ; home-shepherd-service-type
	#:use-module (gnu packages audio) ; qpwgraph
	#:use-module (gnu packages glib) ; glib
	#:use-module (gnu packages kde-utils) ; ark kate kcalc
	#:use-module (gnu packages kde-plasma) ; plasma-disks
	#:use-module (gnu packages kde-internet) ; kdeconnect
	#:use-module (gnu packages qt) ; qtbase
	#:use-module (gnu packages commencement) ; gcc-toolchain
	#:use-module (gnu packages compression) ; unzip
	#:use-module (gnu packages kde-graphics) ; okular gwenview
	#:use-module (gnu packages rust-apps) ; ripgrep uv
	#:use-module (gnu packages package-management) ; flatpak
	#:use-module (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
	#:use-module (gnu packages shells) ; fish fish-foreign-env
	#:use-module (gnu packages shellutils) ; starship direnv
	#:use-module (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
	#:use-module (gnu packages gnupg) ; gnupg
	#:use-module (gnu packages base) ; coreutils
	#:use-module (gnu packages emacs) ; emacs
	#:use-module (gnu packages fonts) ; font-nerd-jetbrains-mono
	#:use-module (gnu packages version-control) ; git hut
	#:use-module (gnu packages xdisorg) ; xsettingsd
	#:use-module (gnu packages ssh) ; openssh
	#:use-module (gnu packages rust-apps) ; ripgrep
	#:use-module (gnu packages xorg) ; xrdb
	#:use-module (gnu packages pretty-print) ; source-highlight
	#:use-module (gnu packages freedesktop) ; xdg-desktop-portal-(kde|gtk) xdg-utils
	#:use-module (gnu packages web); jq
	#:use-module (gnu packages video); vlc
	#:use-module (gnu packages virtualization) ; libvirt
	#:use-module (gnu packages kde-xyz) ; plasma-applet-kde-material-you-colors
	#:use-module (gnu packages haskell-xyz) ; pandoc
	#:use-module (gnu packages containers) ; podman podman-compose
	#:use-module (gnu packages tor-browsers) ; tor-browser
	#:use-module (gnu packages sync) ; rclone
	#:use-module (gnu packages ncdu) ; ncdu
	#:use-module (gnu packages xdisorg) ; wl-clipboard
	#:use-module (gnu packages gl) ; mesa
	#:use-module (nongnu packages game-client) ; protonup steam
	#:use-module (nonguix multiarch-container) ; nonguix-container, fhs-union
	#:use-module (nongnu packages mozilla) ; firefox
	#:use-module (tuco packages games) ; lsfg-vk
	#:use-module (guix gexp) ; local-file
	#:use-module (guix channels) ; guix channels
	#:use-module (tuco packages virtualization)) ; quickemu

(define steam-lsfg-vk
	(nonguix-container->package
	 (nonguix-container
		(inherit (steam-container-for mesa))
		(union64
		 (fhs-union `(,@(@@ (nongnu packages game-client) steam-container-libs)
									("lsfg-vk" ,lsfg-vk))
								#:name "fhs-union-64")))))

(define home
	(home-environment
	 (packages
		(list
		 (list glib "bin")
		 ;; utils
		 ark
		 plasma-disks
		 kdeconnect
		 qtbase
		 kcalc
		 kate
		 unzip
		 okular
		 openssh
		 ripgrep
		 xrdb
		 source-highlight
		 jq
		 quickemu
		 libvirt
		 steam-lsfg-vk
		 lsfg-vk
		 protonup
		 vlc
		 gwenview
		 starship
		 direnv
		 podman
		 podman-compose
		 font-nerd-jetbrains-mono
		 torbrowser
		 rclone
		 firefox
		 pandoc
		 qpwgraph
		 fish-foreign-env
		 wl-clipboard
		 ncdu
		 hut
		 xdg-utils
		 ;; pkg manager
		 flatpak
		 ;; deps
		 libdbusmenu
		 appmenu-gtk-module
		 fish
		 gnupg
		 coreutils
		 emacs-next-pgtk
		 ripgrep
		 git
		 (list git "send-email")
		 gcc-toolchain
		 xsettingsd
		 xdg-desktop-portal-gtk
		 xdg-desktop-portal-kde
		 plasma-applet-kde-material-you-colors))

	 (services
		(list
		 (service home-ssh-agent-service-type)

		 (service home-dbus-service-type)

		 (service home-gpg-agent-service-type
							(home-gpg-agent-configuration
							 (pinentry-program
								(file-append pinentry "/bin/pinentry"))))

		 (service home-pipewire-service-type)

		 (service home-xdg-user-directories-service-type)

		 (simple-service 'podman-socket
										 home-shepherd-service-type
										 (list (shepherd-service
														(provision '(podman-socket))
														(documentation "Rootless Podman REST API service.")
														(start #~(make-systemd-constructor
																			(list #$(file-append podman "/bin/podman")
																						"system" "service" "--time=0")
																			(list (endpoint
																						 (make-socket-address
																							AF_UNIX
																							(string-append (getenv "XDG_RUNTIME_DIR")
																														 "/podman/podman.sock"))))))
														(stop #~(make-systemd-destructor)))))

		 (simple-service 'home-shell-environment-variables
										 home-environment-variables-service-type
										 `(("PATH" . "$HOME/.local/bin:$PATH")
											 ("XDG_DATA_DIRS" . ,(string-append
																						"/var/lib/flatpak/exports/share:"
																						"$XDG_DATA_HOME/flatpak/exports/share:"
																						"$XDG_DATA_DIRS"))
											 ("LESSOPEN" . ,#~(string-append
																				 "| "
																				 #$(file-append source-highlight
																												"/bin/src-hilite-lesspipe.sh")
																				 " %s"))
											 ("LESS" . " --raw-control-chars --tabs 2 --LINE-NUMBERS ")))

		 (simple-service 'home-extra-channels
										 home-channels-service-type
										 (list (channel
														(name 'nonguix)
														(url "https://gitlab.com/nonguix/nonguix")
														(introduction
														 (make-channel-introduction
															"897c1a470da759236cc11798f4e0a5f7d4d59fbc"
															(openpgp-fingerprint
															 "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5"))))
													 (channel
														(name 'tuco)
														(branch "main")
														(url "https://codeberg.org/niqc/tuco")
														(introduction
														 (make-channel-introduction
															"5728b7a5854267de9ef9f30300d946fbb72f8ea4"
															(openpgp-fingerprint
															 "EA18 B34E FD42 9D71 B9D5 4D3D CB9A 70FA CE87 C135"))))))))))

home
