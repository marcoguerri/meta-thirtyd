IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_FEATURE_remote = "allow-root-login"

IMAGE_INSTALL += " \
    dhcp-client \
    git \
    iptables \
    shadow \
    ssh-hardening \
    iptables-rules \
    linux-firmware \
    google-auth \
    ntpdate \
    ddclient \
    dnsmasq \
    lighttpd \
    bash \
    kernel-modules \
    psmisc \
    procps \
    "
