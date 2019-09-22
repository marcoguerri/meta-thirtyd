# Building the container
The container includes a complete openembedded build environment.
```
sudo scripts/build_container.sh <IMAGE_TAG>
```

# Running the build inside the container
```
sudo scripts/run_build_in_container.sh
```

# Run image in qemu
TODO

# Running the relay


```
sudo /usr/sbin/dhcrelay -d -i docker0 <DHCP_SERVER> -U <OUTGRESS_INTERFACE>
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



