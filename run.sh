#!/bin/bash
set -eu

[[ $(whoami) != "root" ]] && echo "Please run this script as root" && exit 1

if docker volume inspect oe_build_volume >& /dev/null; then
  echo "Docker volume oe_build_volume already exists..."
else 
  echo "Creating docker volume"
  docker volume create oe_build_volume
fi

if docker inspect c_oe_build >& /dev/null; then
  echo "Docker container already exists, restarting..."
  docker stop c_oe_build
  docker start -ai c_oe_build
else

  if ! docker image inspect oe_build >& /dev/null; then
    echo "Image does not exist, building it..."
    docker build -t oe_build . 
  fi
  echo "Creating container based on oe_build image"
  docker run \
   --cap-add=ALL \
   --cap-add=NET_ADMIN \
   --cap-add=SETUID \
   --cap-add=SETGID \
   --cap-add=AUDIT_WRITE \
   -v oe_build_volume:/home/dev/openembedded/build \
   --device /dev/net/tun:/dev/net/tun \
   -it \
   --name c_oe_build oe_build \
   /home/dev/build.sh
fi
