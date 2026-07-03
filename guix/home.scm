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
 (gnu packages kde-plasma) ; plasma-disks
 (gnu packages kde-internet) ; kdeconnect
 (gnu packages qt) ; qtbase
 (gnu packages commencement) ; gcc-toolchain
 (gnu packages compression) ; unzip
 (gnu packages kde-graphics) ; okular
 (gnu packages rust-apps) ; ripgrep uv
 (gnu packages package-management) ; flatpak
 (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
 (gnu packages shells) ; fish
 (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
 (gnu packages gnupg) ; gnupg
 (gnu packages base) ; coreutils
 (gnu packages emacs) ; emacs
 (gnu packages version-control) ; git
 (gnu packages xdisorg) ; xsettingsd
 (gnu packages ssh) ; openssh
 (gnu packages rust-apps) ; ripgrep
 (guix gexp) ; local-file
 (guix channels) ; guix channels
 (saayix packages binaries)) ; zen-browser-bin

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
	 ))

 (services
	(list
	 (service home-ssh-agent-service-type)

	 (service home-dbus-service-type)

	 (service home-gpg-agent-service-type
						(home-gpg-agent-configuration
						 (pinentry-program
							(file-append pinentry-qt "/bin/pinentry-qt"))))

	 (service home-pipewire-service-type
						(home-pipewire-configuration
						 (wireplumber wireplumber-minimal)))

	 (service home-bash-service-type
						(home-bash-configuration
						 (aliases '())
						 (bashrc (list (local-file "/home/nick/.bashrc" "bashrc")))))

	 (service home-xdg-user-directories-service-type
						(home-xdg-user-directories-configuration
						 (desktop			"$HOME/Desktop/")
						 (documents		"$HOME/Documents/")
						 (download		"$HOME/Downloads/")
						 (music				"$HOME/Music/")
						 (pictures		"$HOME/Pictures/")
						 (videos			"$HOME/Videos/")
						 (templates		"$HOME/Templates")
						 (publicshare "$HOME/Public")))

	 (simple-service 'home-shell-environment-variables
									 home-environment-variables-service-type
									 `(("PATH" . "$HOME/.local/bin:$PATH")
				 ("XDG_DATA_DIRS" . "/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share:$XDG_DATA_DIRS")))

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
				(name 'radix)
				(url "https://codeberg.org/anemofilia/radix.git")
				(branch "main")
				(introduction
				 (make-channel-introduction
					"f9130e11e35d2c147c6764ef85542dc58dc09c4f"
					(openpgp-fingerprint
					 "F164 709E 5FC7 B32B AEC7 9F37 1F2E 76AC E3F5 31C8"))))
			 (channel
				(name 'rosenthal)
				(url "https://codeberg.org/hako/rosenthal.git")
				(branch "trunk")
				(introduction
				 (make-channel-introduction
					"7677db76330121a901604dfbad19077893865f35"
					(openpgp-fingerprint
					 "13E7 6CD6 E649 C28C 3385	 4DF5 5E5A A665 6149 17F7")))))))))
