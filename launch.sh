#!/bin/sh
OE_ROOT=/home/mguerri/nas/Data/Technical/development/rpi
NFS_ROOT=/srv/rpi
RPI_IP=192.168.0.8

cd ../openembedded-core
export BBPATH=$OE_ROOT/openembedded-core/build
export PATH=$PATH:$OE_ROOT/openembedded-core/bitbake/bin
echo $PATH

./oe-init-build-env

bitbake rpi-basic-image

# New fs image is now available. Rpi won't take this very well.
sudo systemctl stop nfs-kernel-server
echo "Umounting..."
sleep 5
sudo umount $NFS_ROOT
sudo mount $OE_ROOT/openembedded-core/build/tmp-glibc/deploy/images/raspberrypi/rpi-basic-image-raspberrypi.ext3 $NFS_ROOT
sudo systemctl start nfs-kernel-server
