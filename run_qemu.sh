#!/bin/sh
set -eux
home=~dev
build_root=${home}/openembedded/openembedded-core/build/tmp-glibc/deploy/images/qemux86-64


# Docker container must run with NET_ADMIN capabilities, and user inside the container must 
# be root or have NET_ADMIN capability assigned to /bin/ip

#  sudo docker run -u root --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -ti marcoguerri/oe_env

# Setup bridge
ip link set down dev br0 && brctl delbr br0 || true

ip link add name br0 type bridge
ip link set eth0 master br0
ip addr flush dev eth0
dhclient br0

ip link set down dev tap0 && ip link delete tap0 || true

# Setup tap device for qemu
ip tuntap add tap0 mode tap
brctl addif br0 tap0

(
    cd ${build_root}
    qemu-system-x86_64 -kernel bzImage \
                       --append "console=ttyS0 root=/dev/vda" \
                       -nographic \
                       -serial mon:stdio \
                       -drive file=core-image-minimal-qemux86-64.ext4,if=virtio,format=raw \
                       -net nic,model=virtio,macaddr=00:11:22:33:44:55 \
                       -net tap,ifname=tap0
)

