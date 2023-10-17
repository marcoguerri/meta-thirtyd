#!/bin/bash
set -eu

[[ $(whoami) != "root" ]] && echo "Please run this script as root" && exit 1

if docker volume inspect oe_build_volume >& /dev/null; then
  echo "Docker volume oe_build_volume already exists..."
else 
  echo "Creating docker volume"
  docker volume create oe_build_volume
fi

if docker inspect c_oe_build_caps >& /dev/null; then
  echo "Docker container already exists, restarting..."
  docker stop c_oe_build_caps
  docker start -ai c_oe_build_caps
else
  if ! docker image inspect oe_build >& /dev/null; then
    echo "Image does not exist, building it..."
    docker build --no-cache -t oe_build . 
  fi
  echo "Creating container based on oe_build image"
  docker run \
   --cap-drop ALL \
   --cap-add=NET_ADMIN \
   --cap-add=SETUID \
   --cap-add=SETGID \
   -v oe_build_volume:/home/dev/openembedded/build \
   --device /dev/net/tun:/dev/net/tun \
   -it \
   -e HOME=/home/dev \
   --user root \
   --name cc_oe_build_caps oe_build \
   capsh  --keep=1 --user=dev --inh=cap_net_admin=i --
fi

# Do not give CAP_DAC_OVERRIDE to root so that it cannot write to users' homes
# Set HOME for bash spawned by capsh. It is otherwise set to /root
