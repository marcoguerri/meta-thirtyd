#!/bin/bash

set -x

[[ $(whoami) != "root" ]] && echo "Please run this script as root" && exit 1

( 
    docker volume inspect oe_build_bolume >& /dev/null && \
    echo "Docker volume oe_build_volume already exists..." || \
    docker volume create oe_build_volume

    docker inspect oe_build >& /dev/null && \
    echo "Docker container already exists, restarting..." && \
    docker stop oe_build && \
    docker start -ai oe_build 

) || docker run \
	--cap-add=NET_ADMIN \
	-v oe_build_volume:/home/dev/openembedded/build \
	--device /dev/net/tun:/dev/net/tun \
	-it \
	--name oe_build oe_build \
	/home/dev/build_image.sh
