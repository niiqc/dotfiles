(use-modules (shepherd service))

;; herd load root file.scm

(define network-ready
	(service
	 '(network-ready)
	 #:one-shot? #t
	 #:start (make-forkexec-constructor
						(list "/run/current-system/profile/bin/nm-online"
									"-q" "-t" "120"))))

(define rclone-onedrive
	(service
	 '(rclone-onedrive onedrive)
	 #:start (make-forkexec-constructor
						(list
						 "/home/nick/.guix-home/profile/bin/rclone" "mount"
						 "onedrive:rclone" "/home/nick/OneDrive/"
						 "--cache-dir" "/home/nick/.rclone-cache"
						 "--vfs-cache-mode" "full"
						 "--dir-cache-time" "72h"
						 "--vfs-cache-max-size" "1G"
						 "--vfs-cache-max-age" "2d"
						 "--vfs-read-chunk-size" "128M"
						 "--vfs-read-chunk-size-limit" "1G"
						 "--tpslimit" "10"
						 "--attr-timeout" "1s"
						 "--poll-interval" "15s"
						 "--log-level" "INFO"
						 "--buffer-size" "64M"
						 "--transfers" "8"
						 "--log-file" "/tmp/rclone.log"))
	 #:stop (lambda (pid . args)
						((make-kill-destructor) pid)
						(system* "/run/privileged/bin/fusermount3" "-uz"
										 "/home/nick/OneDrive") #f)
	 #:requirement '(network-ready)
	 #:respawn? #t))

(register-services (list network-ready rclone-onedrive))
(start-in-the-background '(rclone-onedrive))
