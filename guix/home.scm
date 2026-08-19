(use-modules
 (gnu home)
 (gnu home services)
 (gnu home services desktop)
 (gnu home services gnupg)
 (gnu home services shells)
 (gnu home services xdg) ; xdg-user-dirs-service-type
 (gnu home services sound) ; home-pipewire-service-type
 (gnu home services guix) ; guix channels
 (gnu home services ssh) ; home-ssh-agent-service-type
 (gnu packages linux) ; wirepluber
 (gnu packages glib) ; glib
 (gnu packages kde-utils) ; ark kate kcalc
 (gnu packages kde-plasma) ; plasma-disks plasma-browser-integration
 (gnu packages kde-internet) ; kdeconnect
 (gnu packages qt) ; qtbase
 (gnu packages commencement) ; gcc-toolchain
 (gnu packages compression) ; unzip
 (gnu packages kde-graphics) ; okular gwenview
 (gnu packages rust-apps) ; ripgrep uv
 (gnu packages package-management) ; flatpak
 (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
 (gnu packages shells) ; fish
 (gnu packages shellutils) ; starship direnv
 (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
 (gnu packages gnupg) ; gnupg
 (gnu packages base) ; coreutils
 (gnu packages emacs) ; emacs
 (gnu packages version-control) ; git
 (gnu packages xdisorg) ; xsettingsd
 (gnu packages ssh) ; openssh
 (gnu packages rust-apps) ; ripgrep
 (gnu packages xorg) ; xrdb
 (gnu packages pretty-print) ; source-highlight
 (gnu packages freedesktop) ; xdg-desktop-portal-(kde|gtk)
 (gnu packages web); jq
 (gnu packages video); vlc
 (gnu packages virtualization) ; libvirt
 (gnu packages kde-xyz) ; plasma-applet-kde-material-you-colors
 (nongnu packages game-client) ; protonup steam
 (guix gexp) ; local-file
 (guix channels) ; guix channels
 (saayix packages binaries) ; zen-browser-bin
 (tuco packages virtualization)) ; quickemu

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
	 steam
	 protonup
	 vlc
	 gwenview
	 plasma-browser-integration
	 starship
	 direnv
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
	 gcc-toolchain
	 xsettingsd
	 zen-browser-bin
	 xdg-desktop-portal-gtk
	 xdg-desktop-portal-kde
	 plasma-applet-kde-material-you-colors
	 ))

 (services
	(list
	 (service home-ssh-agent-service-type)

	 (service home-dbus-service-type)

	 (service home-gpg-agent-service-type
						(home-gpg-agent-configuration
						 (pinentry-program
							(file-append pinentry "/bin/pinentry"))))

	 (service home-pipewire-service-type
						(home-pipewire-configuration
						 (wireplumber wireplumber-minimal)))

	 (service home-bash-service-type
						(home-bash-configuration
						 (aliases '())
						 (bashrc (list (local-file "/home/nick/.bashrc" "bashrc")))))

	 (service home-xdg-user-directories-service-type)

	 (simple-service 'home-shell-environment-variables
									 home-environment-variables-service-type
									 `(("PATH" . "$HOME/.local/bin:$PATH")
										 ("XDG_DATA_DIRS" . "/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share:$XDG_DATA_DIRS")
										 ("LESSOPEN" . "| src-hilite-lesspipe.sh %s")
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
				(name 'saayix)
				(branch "main")
				(url "https://codeberg.org/look/saayix")
				(introduction
				 (make-channel-introduction
					"12540f593092e9a177eb8a974a57bb4892327752"
					(openpgp-fingerprint
					 "3FFA 7335 973E 0A49 47FC 0A8C 38D5 96BE 07D3 34AB"))))
			 (channel
				(name 'tuco)
				(branch "main")
				(url "https://codeberg.org/niqc/tuco")
				(introduction
				 (make-channel-introduction
					"5728b7a5854267de9ef9f30300d946fbb72f8ea4"
					(openpgp-fingerprint
					 "EA18 B34E FD42 9D71 B9D5 4D3D CB9A 70FA CE87 C135")))))))))
