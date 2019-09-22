#!/bin/bash
#set -e


platform=${1}

case "$platform" in
        x86_64 ) echo "Starting qemu x86_64"; build=1;;
        arm ) echo "Starting qemu arm"; build=0;;
        * ) echo "Invalid platform"; exit 1;;
esac

# Docker container must run with NET_ADMIN capabilities, and user inside the container must
# be root or have NET_ADMIN capability assigned to /bin/ip

#  sudo docker run -u root --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -ti oe_build

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

if [[ ${platform} == "x86_64" ]]; then
(
    deploy_dir=~dev/openembedded/openembedded-core/build/tmp-glibc/deploy/images/qemux86-64
    qemu-system-x86_64 -kernel ${deploy_dir}/bzImage \
                       --append "console=ttyS0 root=/dev/vda" \
                       -nographic \
                       -serial mon:stdio \
                       -drive file=${deploy_dir}/core-image-minimal-qemux86-64.ext4,if=virtio,format=raw \
                       -net nic,model=virtio,macaddr=00:11:22:33:44:55 \
                       -net tap,ifname=tap0
)
else
(
    deploy_dir=~dev/openembedded/build/tmp-glibc/deploy/images/raspberrypi2/
    # Note: all the append kernel command line parameters effectively
    # overwrite what is written in cmdline.txt (the file used by Rpi bootloader
    # to populate kernel command line arguments according to the boot protocol), 
    # which is ignored by qemu.

    # rootdelay is necessary because there seems to be a race condition between
    # the initialization of the partitions from the virtualized sdcard controller
    # and the kernel trying to mount the root device.

    # There will be additional stack traces related to clock initialization, because
    # qemu does not implement a full cprman clock controller, which according to
    # Documentation/devicetree/bindings/clock/brcm,bcm2835-cprman.txt (linux source code)
    # distributes the clock to the audio domain
    qemu-system-arm -M raspi2 \
                        -dtb ${deploy_dir}/bcm2709-rpi-2-b.dtb \
                        -sd ${deploy_dir}/core-image-minimal-raspberrypi2.rpi-sdimg \
                        -kernel ${deploy_dir}/zImage \
                        -m 1G \
                        -smp 4 \
                        -serial mon:stdio \
			-nographic \
                        -append "rw earlyprintk loglevel=8  console=ttyAMA0 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=5"
)
fi

