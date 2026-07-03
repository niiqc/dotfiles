(define-module (vaio)
  #:use-module (gnu system)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system uuid)
  #:use-module (gnu system file-systems)
  #:use-module (base))

(define vaio
  (operating-system
   (inherit base)
   (host-name "vaio")

   (mapped-devices
    (list
     (mapped-device
      (source (uuid "fc422a08-a1a4-4de2-a872-083934975a2d"))
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
      (device (uuid "3B03-BEDD" 'fat32))
      (type "vfat"))
     %base-file-systems))))

vaio
