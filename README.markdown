# Custom layer to configure a Raspberry Pi as a SSH gateway

## How to setup the build environment:

This image is developed to work with the ``morty`` release of the Yocto project
(i.e. morty branches for openembedded-core, meta-openembedded, meta-raspberrypi
and bitbake version 1.32).
```
sudo apt-get install diffstat gawk chrpath
mkdir openembedded && cd openembedded
git clone https://github.com/openembedded/openembedded-core.git
cd openembedded-core
git checkout -b morty remotes/origin/morty
git clone git://git.openembedded.org/bitbake.git
cd bitbake
git checkout -b 1.32 remotes/origin/1.32
cd ../..
git clone git://github.com/openembedded/meta-openembedded.git
cd meta-openembedded
git checkout -b morty remotes/origin/morty
cd ..
git clone https://github.com/agherzan/meta-raspberrypi
cd meta-raspberrypi
git checkout -b morty remotes/origin/morty
cd ..
install -d openembedded-core/build/conf/
cp openembedded-core/meta/conf/local.conf.sample openembedded-core/build/conf/local.conf
```


Apply the following changes
* Set machine to "raspberrypi" in openembedded-core/build/conf/local.conf
* Add DISTRO="thirtyd"

Prepare the bblayers file:
```
cp openembedded-core/meta/conf/bblayers.conf.sample openembedded-core/build/conf/bblayers.conf
```

Set BBLAYERS in bblayers.conf as follows:

```
    BLAYERS ?= "
      <OE-ROOT>/openembedded-core/meta \
      <OE-ROOT>/meta-raspberrypi \
      <OE-ROOT>/meta-openembedded/meta-oe \
      <OE-ROOT>/meta-openembedded/meta-networking \
      <OE-ROOT>/meta-openembedded/meta-python \
      <OE-ROOT>/meta-openembedded/meta-webserver \
      <OE-ROOT>/meta-thirtyd/ \
    "
```

Setup the environment:

```
cd openembedded-core
export BBPATH=<OE-ROOT>openembedded-core/build
export PATH=$PATH:<OE-ROOT>/openembedded-core/bitbake/bin
. ./oe-init-build-env
```

Trigger the compilation:

```
bitbake rpi-basic-image
```

# Customization of the image

## Initial users and passwords
To add additional users at compilation time, modify EXTRA_USER_PARAMS in meta-thirtyd/conf/distro/thirtyd.conf, e.g:

```
EXTRA_USERS_PARAMS = " \
    usermod -p '\$1\$fN6waiIO$rnPtE1uOsCHnOoJ2cRBFZ/' root; \
    useradd -p '\$1\$Nhj07r30\$lpZbyxQH4KFE2eXxbfj7V0' mguerri; \
    "
```

To generate the hash of the password openssl can be used (dollar sign in the resulting
has must be escaped):

```
openssl passwd -1 <PASSWORD>
```











