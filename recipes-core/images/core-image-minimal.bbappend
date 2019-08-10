IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_INSTALL += " \
    dhcp-client \
    git \
    iptables \
    shadow \
    ssh-hardening \
    iptables-rules \
    google-auth \
    ntp \
    ntpdate \
    ddclient \
    dnsmasq \
    lighttpd \
    bash \
    "
