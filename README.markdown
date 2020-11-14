# Building the container
The container implements a complete openembedded build environment. The `build` directory is persisted
in an external volume. The container can be build as follows:
```
sudo ./run.sh
```

The `run.sh` script is relatively simple and can be audited to decide if you are fine with running it as root.

The container itself runs with `--cap-add=ALL`. This could certainly be improved and tailored to the build process.

# Building the image inside the container
The main container entry point is `scripts/build.sh`, which setsup the virtual env environment for bitbake and 
runs `bitbake core-image-minimal`. The script will ask for confirmation and if denied, it will drop to a shell.
From there, the build can be re-started simply with `bitbake core-image-minimal`.

# Run image in qemu
Within the container `/home/dev/emulate.sh` is a helper script which executes the image built by bitbake via qemu.
At the moment is supports two machine types (as defined in `<OE_ROOT>/build/conf/local.conf`:
* qemux86-64
* raspberrypi2

`raspberrypi2` has significant limitations in the emulation (e.g. networking is not emulated). See `/home/dev/emulate.sh`
for details.

# qemu network configuration

qemu rus with a tap network backend. In the container, `tap0` is bridged with the main interface. `emulate.sh` runs
`dhclient` on the bridge interface and dynamic address is also expected to be assigned to the interface in the virtualized
environment. The whole setup has been tested with docker `bridge` driver, which also means that IP assigned is responsibility
of `dockerd` and a DHCP server would not be supported. For simplicity, my setup still included a DHCP server with IPs assigned
statically via config file based on the subnet to which the main bridge on the host belonged. For example, it would be as simple
as running:

```
sudo /usr/sbin/dhcpd -4 -f -cf /tmp/dhcp.conf docker0 -d
```

With `dhcp.conf`:
```
option domain-name-servers 8.8.8.8, 8.8.4.4;
option subnet-mask 255.255.255.0;
option routers 172.18.0.1;
subnet 172.18.0.0 netmask 255.255.255.0 {
  range 172.18.0.0 172.18.0.250;
}

host bridge {
  hardware ethernet 02:42:ac:12:00:04;
  fixed-address 172.18.0.2;
}

host vm {
  hardware ethernet 00:11:22:33:44:55;
  fixed-address 172.18.0.3;
}
```

Within the container, `/etc/resolv.conf` cannot be modified. So this setup is really a hack for testing purposes.
A proper setup integrated with DHCP infra would require a network driver which as far as I know is not officially
supported yet by Docker.

# Customization of the image

## Initial users and passwords
To add additional users at compilation time, modify EXTRA_USER_PARAMS in meta-thirtyd/conf/distro/thirtyd.conf, e.g:

```
EXTRA_USERS_PARAMS = " \
    usermod -p '\$1\$fN6waiIO$rnPtE1uOsCHnOoJ2cRBFZ/' root; \
    useradd -p '\$1\$Nhj07r30\$lpZbyxQH4KFE2eXxbfj7V0' user1; \
    "
```

openssl can be used to generate the hash of the password (dollar sign in the resulting
has must be escaped):

```
openssl passwd -1 <PASSWORD>
```



