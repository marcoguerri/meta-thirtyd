#!/bin/bash

set -ex

[[ $(whoami) != "dev" ]] && echo "This script should run as user dev!" && exit 1

virtualenv -p /usr/bin/python2.7 ${HOME}/p27
cd ~dev/openembedded/openembedded-core 
source ~dev/p27/bin/activate
source oe-init-build-env /home/dev/openembedded/build

build=0
if [ -t 1 ]; then
    read -p "Continue (y/n)?" choice
    case "$choice" in 
      y|Y ) echo "Starting build"; build=1;;
      n|N ) echo "Skipping build"; build=0;;
      * ) echo "invalid";;
    esac
fi
[[ ${build} -eq 1 ]] && bitbake core-image-minimal || /bin/bash
