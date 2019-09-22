#!/bin/bash


[[ $(whoami) != "root" ]] && echo "This script should be executed as root" && exit 1
[[ -z ${1} ]] && echo "Usage: `basename $0` <tag>" && exit 1

docker build -t ${1} .
