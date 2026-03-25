(use-modules
 (guix packages)
 (gnu packages firmware)
 (gnu packages nss) ;; nss certs
 (gnu packages version-control)
 (gnu packages build-tools)
 (gnu packages gcc)
 (gnu packages cross-toolchain)
 (gnu packages textutils))

(define (base-pkgs)
  (list
   qmk
   nss-certs
   git
   dos2unix
   gcc-cross-avr-toolchain))

(packages->manifest (append (base-pkgs)))

