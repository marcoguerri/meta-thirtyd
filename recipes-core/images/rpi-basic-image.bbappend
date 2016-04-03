IMAGE_FEATURES_remove = "ssh-server-dropbear"
IMAGE_INSTALL += " \
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
    "
