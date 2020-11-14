IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_FEATURES_remove = "debug-tweaks allow-root-login allow-empty-password packagegroup-base-extended"

IMAGE_LINGUAS = "en-us"

IMAGE_INSTALL += " \
    dhcp-client \
    git \
    iptables \
    hostapd \
    shadow \
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
    iw \
    tmux \
    glibc-utils \
    "
