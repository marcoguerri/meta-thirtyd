# Custom layer to configure a Raspberry Pi as a SSH gateway

## How to setup the build environment:

The following instructions refers to specific HEADs of each repository. The 
image is not guaranteed to be working under different revisions.
```
sudo apt-get install diffstat gawk chrpath
mkdir openembedded && cd openembedded
git clone https://github.com/openembedded/openembedded-core.git
cd openembedded-core
git clone git://git.openembedded.org/bitbake.git
cd ..
git clone git://github.com/openembedded/meta-openembedded.git
git clone https://github.com/agherzan/meta-raspberrypi
install -d openembedded-core/build/conf/
cp openembedded-core/meta/conf/local.conf.sample openembedded-core/build/conf/local.conf
```

Checkout each repo as follows:

```
openembedded-core = "master:6f98c39418c60b7c0b25b30983d2e5257158a6a4"
meta-raspberrypi  = "master:0776b86c6629b7294ff61e67609f2d4e10e9712c"
meta-openembedded = "master:ea319464b673cbf9a416b582dc4766faeb998430"
meta-thirtyd      = "master:944bf9b495005e729facf4706f0199392debc055"
```

Perform the following changes
* Set machine to "raspberrypi" in openembedded-core/build/conf/local.conf
* Add DISTRO="td"
* Remove ASSUME_PROVIDED += "libsdl-native"

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

Proceed as follows:

```
cd openembedded-core
export BBPATH=<OE-ROOT>openembedded-core/build
export PATH=$PATH:<OE-ROOT>/openembedded-core/bitbake/bin
./oe-init-build-env
```

Trigger the compilation with:

```
bitbake rpi-basic-image
```

# Customization of the image

## Initial users and passwords
To add additional users at compilation time, modify EXTRA_USER_PARAMS in meta-thirtyd/conf/distro/td.conf, e.g:

```
EXTRA_USERS_PARAMS = " \
    usermod -p '\$1\$fN6waiIO$rnPtE1uOsCHnOoJ2cRBFZ/' root; \
    useradd -p '\$1\$Nhj07r30\$lpZbyxQH4KFE2eXxbfj7V0' mguerri; \
    "
```

To generate the hash of the password run (escape then dollar signs):

```
openssl passwd -1 <PASSWORD>
```











