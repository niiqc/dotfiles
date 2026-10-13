(define-module (base)
	#| GNU Packages |#
	#:use-module (gnu packages file)
	#:use-module (gnu packages shells)
	#:use-module (gnu packages fonts)
	#:use-module (gnu packages compression)
	#:use-module (gnu packages display-managers)
	#:use-module (gnu packages virtualization)

	#| GNU System |#
	#:use-module (gnu)
	#:use-module (gnu system)
	#:use-module (gnu system privilege)
	#:use-module (gnu system accounts) ; subid-range
	#:use-module (gnu services)
	#:use-module (gnu services base)
	#:use-module (gnu services desktop) ; plasma-desktop-service-type kwallet-service-type
	#:use-module (gnu services linux)
	#:use-module (gnu services pm)
	#:use-module (gnu services sysctl)
	#:use-module (gnu services xorg)
	#:use-module (gnu services sddm)
	#:use-module (gnu services virtualization)
	#:use-module (gnu services networking) ; nftables-service-type, nftables-configuration
	#:use-module (gnu services containers) ; rootless-podman-service-type, rootless-podman-configuration

	#| Guix |#
	#:use-module (guix channels)

	#| Nonguix |#
	#:use-module (nongnu packages linux)
	#:use-module (nongnu system linux-initrd)

	#| Tuco |#
	#:use-module (tuco system monitoring)

	#:export (base))

(define nonguix-signing-key
	(plain-file "nonguix.pub"
							"(public-key (ecc (curve Ed25519)
 (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define ruleset-nftables
	(plain-file "nftables.conf"
							"\
table inet filter {
  chain input {
    type filter hook input priority filter; policy accept;
  }

  chain forward {
    type filter hook forward priority filter; policy drop;
    iifname \"virbr0\" accept
    oifname \"virbr0\" accept
  }

  chain output {
    type filter hook output priority filter; policy accept;
  }
}"))

(define base
	(operating-system
	 (locale "en_US.utf8")
	 (timezone "America/Sao_Paulo")
	 (keyboard-layout (keyboard-layout "us" "altgr-intl"))
	 (host-name "base")
	 (kernel linux)
	 (kernel-arguments
		(list "loglevel=3"
					"quiet"))
	 (firmware (list linux-firmware))
	 (initrd microcode-initrd)

	 ;; We don't use any file-systems for the base operating-system
	 (file-systems '())

	 (bootloader (bootloader-configuration
								(bootloader grub-efi-bootloader)
								(targets (list "/boot/efi"))
								(keyboard-layout keyboard-layout)))

	 (users (cons* (user-account
									(name "nick")
									(comment "nick")
									(shell (file-append fish "/bin/fish"))
									(group "users")
									(home-directory "/home/nick")
									(supplementary-groups '("wheel" "netdev" "audio" "video" "kvm" "libvirt" "cgroup")))
								 %base-user-accounts))

	 (privileged-programs
		(append (list (privileged-program
									 (program (file-append qemu "/libexec/qemu-bridge-helper"))
									 (setuid? #t)))
						%default-privileged-programs))

	 (packages
		(append
		 (list
			gzip unzip xz
			file
			font-google-noto font-google-noto-emoji font-sarasa-gothic)
		 %base-packages))

	 ;; Services
	 (services
		(append
		 (list
			(service plasma-desktop-service-type)

			(service kwallet-service-type)

			;; Sddm
			(service sddm-service-type
							 (sddm-configuration
								(theme "breeze")
								(sddm sddm)))

			;; Power profiles daemon
			(service power-profiles-daemon-service-type)

			;; Zram configuration
			(service zram-device-service-type
							 (zram-device-configuration
								(priority 100)
								(size (ram-total))
								(compression-algorithm 'zstd)))

			(service libvirt-service-type
							 (libvirt-configuration
								(tls-port "16555")
								(qemu qemu)))

			(service virtlog-service-type
							 (virtlog-configuration
								(max-clients 1000)))

			(simple-service 'qemu-bridge-config
								etc-service-type
								(list `("qemu/bridge.conf"
												,(plain-file "bridge.conf" "allow virbr0\n"))))

			(service nftables-service-type
							 (nftables-configuration
								(ruleset ruleset-nftables)))

			(service rootless-podman-service-type
							 (rootless-podman-configuration
								(subgids (list (subid-range (name "nick"))))
								(subuids (list (subid-range (name "nick"))))))

			(simple-service 'zram-sysctl-settings
											sysctl-service-type
											`(("vm.swappiness" . "180")
												("vm.watermark_boost_factor" . "0")
												("vm.watermark_scale_factor" . "125")
												("vm.page-cluster" . "0")))

			(simple-service 'nonguix-substitutes
											guix-service-type
											(guix-extension
												(substitute-urls '("https://substitutes.nonguix.org"))
												(authorized-keys (list nonguix-signing-key)))))

		 (modify-services %desktop-services
											(delete gdm-service-type))))))
