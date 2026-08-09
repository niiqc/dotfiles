(define-module (desktop)
  #:use-module (gnu system)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system uuid)
  #:use-module (gnu system file-systems)
  #:use-module (base))

(define desktop
  (operating-system
   (inherit base)
   (host-name "guix")
   
   (mapped-devices
    (list
     (mapped-device
      (source (uuid "278e3819-1918-4fc4-badf-bc1b5fc87d7d"))
      (target "cryptroot")
      (type luks-device-mapping))))
   
   (file-systems
    (cons*
     (file-system
      (mount-point "/")
      (device "/dev/mapper/cryptroot")
      (type "btrfs")
      (dependencies mapped-devices)
      (options "compress=zstd"))
     (file-system
      (mount-point "/boot/efi")
      (device (uuid "350E-6955" 'fat32))
      (type "vfat")) 
     %base-file-systems))))

desktop
