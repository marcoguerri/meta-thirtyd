FEATURE_INSTALL = "ssh-server-openssh"

IMAGE_INSTALL += " \
    dhcp-client \
    git \
    iptables \
    shadow \
    ssh-hardening \
    iptables-rules \
    openssh \
    google-auth \
    ntp \
    ntpdate \
    resolvconf \
    ddclient \
    dnsmasq \
    nginx \
    lighttpd \
    "
