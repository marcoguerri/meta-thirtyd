#!/bin/bash

[[ $(whoami) == "root" ]] || ( echo "Please run this script as root" && exit 1)
( 
    docker inspect oe_build >& /dev/null && \
    echo "Docker container already exists, restarting..." && \
    docker stop oe_build && \
    docker start -ai oe_build 
) || docker run --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -it --name oe_build oe_build /home/dev/build_image.sh 
