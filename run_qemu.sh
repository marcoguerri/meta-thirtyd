#!/bin/sh
home=~dev
build_root=${home}/openembedded/openembedded-core/build/tmp-glibc/deploy/images/qemux86-64
cd (
    ${build_root}
    qemu-system-x86_64 -kernel bzImage --append "console=ttyS0 root=/dev/vda" -nographic -serial mon:stdio -drive file=core-image-minimal-qemux86-64.ext4,if=virtio,format=raw
)
