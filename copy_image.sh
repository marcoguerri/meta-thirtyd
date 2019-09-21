#!/bin/bash

set -eu

[[ $(whoami) == "root" ]] || ( echo "Please run this script as root" && exit 1)
docker cp -L oe_build:/home/dev/openembedded/build/tmp-glibc/deploy/images/raspberrypi2/core-image-minimal-raspberrypi2.rpi-sdimg .
