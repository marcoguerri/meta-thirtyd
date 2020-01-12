#!/bin/bash
set -ex


platform=${1}

case "$platform" in
        x86_64 ) echo "Starting qemu x86_64"; build=1;;
        arm ) echo "Starting qemu arm"; build=0;;
        * ) echo "Invalid platform"; exit 1;;
esac

# Container privileges required:
#
# * sudo on /sbin/ip,/sbin/ip,/sbin/dhclient,/sbin/brctl + CAP_NET_ADMIN + CAP_SETUID + CAP_SETGID + CAP_AUDIT_WRITE
#
#   CAP_NET_ADMIN alon is not sufficient to create a bridge or a tap device. The container,
#   when running as root, has a restricted bounding set of capabilities and CAP_NET_ADMIN,
#   CAP_SETUID, CAP_SETGID, CAP_AUDIT_WRITE are not included in the list.
#
#   Docker does not support adding capabilities to non-root user (via --cap-add), 
#   and inheritable capabilities are not preseved across execve for non-root users. 
#   --cap-add does add CAP_NET_ADMIN to the inheritable and bounding set (but not effective).
#
#   Rules for capabilities assignement after execve:
#   P'(permitted) = (P(inheritable) & F(inheritable)) | (F(permitted) & cap_bset)
#   P'(effective) = F(effective) ? P'(permitted) : 0
#   P'(inheritable) = P(inheritable)    [i.e., unchanged]
#   Where P is old capability set, P' is capability set after execv and F is file capability set.
#   Bounding set is the thread capability bounding set and remains unchanged if not modified.
# 
# * Access to /dev/net/tun to issue ioctl to create tap device. By default the device cgroups has 
#   rwm access to /dev/net/tun. One-liner to check devices.allow for a container: 
#   container_id=0247a6488d52; 
#   sudo cat /sys/fs/cgroup/devices/$(cat /proc/$(sudo docker inspect -f '{{.State.Pid}}' ${container_id})/cgroup | grep devices | awk -F":" '{ print $3 }')/devices.list


# Setup bridge
sudo /sbin/ip link set down dev br0 && /sbin/brctl delbr br0 || true

sudo /sbin/ip link add name br0 type bridge
sudo /sbin/ip link set eth0 master br0
sudo /sbin/ip addr flush dev eth0
sudo /sbin/dhclient br0

sudo /sbin/ip link set down dev tap0 && sudo /sbin/ip link delete tap0 || true

# Setup tap device for qemu
sudo /sbin/ip tuntap add tap0 mode tap
sudo /sbin/brctl addif br0 tap0

if [[ ${platform} == "x86_64" ]]; then
(
    deploy_dir=~dev/openembedded/openembedded-core/build/tmp-glibc/deploy/images/qemux86-64
    qemu-system-x86_64 -kernel ${deploy_dir}/bzImage \
                       --append "console=ttyS0 root=/dev/vda" \
                       -nographic \
                       -serial mon:stdio \
                       -drive file=${deploy_dir}/core-image-minimal-qemux86-64.ext4,if=virtio,format=raw \
                       -device e1000,macaddr=00:11:22:33:44:55,id=hintf \
                       -netdev tap,ifname=tap0,id=hintf,script=no

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

    # Note that the ethernet interface is not supported. On the Raspberri Pi 2, the ethernet
    # interface goes through the USB controller, which is also not supported by the raspi2
    # machine type
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
