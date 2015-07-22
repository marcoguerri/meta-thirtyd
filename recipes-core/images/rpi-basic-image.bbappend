IMAGE_FEATURES_remove = "ssh-server-dropbear"
IMAGE_INSTALL += " \
    iptables \
    shadow \
    dhcp-server \
    dhcp-server-config \
    ssh-hardening \
    iptables-rules \
    openssh \
    google-auth \
    ntp \
    ntpdate \
    "
